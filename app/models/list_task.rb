# == Schema Information
#
# Table name: list_tasks
#
#  id           :integer          not null, primary key
#  list_id      :integer
#  name         :string
#  list_task_id :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ListTask < ApplicationRecord
  belongs_to :list
  belongs_to :list_task, optional: true

  has_many :list_tasks, dependent: :destroy

  STATUS_VALUES = [:opened, :closed]

  enum status: STATUS_VALUES

  validates :name, presence: true
  validates :list, presence: true
  validates :status, presence: true
  validate :validate_list_task

  scope :main_tasks, -> () { where(list_task: nil) }

  def initialize(attrs = {})
    super(attrs)
    self.status ||= :opened
  end

  private

  def validate_list_task
    if list.present? && list_task.present?
      if list.list_tasks.where(id: list_task.id).blank?
        errors.add(:list_task, :invalid_list_task)
      end
    end
  end
end
