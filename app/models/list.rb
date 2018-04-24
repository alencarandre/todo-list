# == Schema Information
#
# Table name: lists
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  user_id     :integer          not null
#  access_type :integer          not null
#  status      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class List < ApplicationRecord
  belongs_to :user
  has_many :list_tasks
  has_many :list_favorites

  STATUS_VALUES = [:opened, :closed]
  ACCESS_TYPE_VALUES = [:shared, :personal]

  enum status: STATUS_VALUES
  enum access_type: ACCESS_TYPE_VALUES

  validates :name, presence: true
  validates :user, presence: true
  validates :access_type, presence: true
  validates :status, presence: true

  before_save :close_task_cascade!, if: :closed?


  scope :by_user, -> (user) { where(user: user) }
  scope :order_created_at_desc, -> { order("created_at DESC") }
  scope :shared_lists, -> { where(access_type: :shared) }
  scope :exclude_user, -> (user) { where.not(user: user) }

  def initialize(attrs = {})
    super
    self.status ||= :opened
  end

  def check_tasks_and_mark_as_opened!
    tasks = ListTask.where(list: self)
    if tasks.select{ |task| task.opened? }.present?
      self.update(status: :opened) if closed?
    end
  end

  def check_tasks_and_mark_as_closed!
    if list_tasks.select{ |task| task.opened? }.blank?
      self.update(status: :closed) if opened?
    end
  end

  def opened!
    closed_tasks = list_tasks.select { |task| task.closed? }.count
    super if list_tasks.blank? || closed_tasks < list_tasks.count
  end

  def favor!(user)
    list_favorites.find_or_create_by(user_id: user.id)
  end

  def unfavor!(user)
    list_favorites.find_by(user_id: user.id).destroy
  end

  def favorite?(user)
    list_favorites.find_by(user_id: user.id)
  end

  private

  def close_task_cascade!
    ListTask.where(list: self).update_all(status: :closed)
  end

end
