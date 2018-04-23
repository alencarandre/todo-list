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

  after_save :close_task_cascade!, if: :closed?
  after_save :open_parent_task_cascade, if: :opened?

  def initialize(attrs = {})
    super(attrs)
    self.status ||= list_task.try(:status) || :opened
  end

  def check_subtasks_and_change_my_status!
    if list_tasks.select { |task| task.opened? }.first.present?
      ListTask.where(id: id).update_all status: :opened
    else
      ListTask.where(id: id).update_all status: :closed
    end
    reload
    list_task.check_subtasks_and_change_my_status! if list_task.present?
  end

  private

  def validate_list_task
    if list.present? && list_task.present?
      if list.list_tasks.where(id: list_task.id).blank?
        errors.add(:list_task, :invalid_list_task)
      end
    end
  end

  def close_task_cascade!
    list_tasks.each { |task| task.closed! if task.opened? }
    list.check_tasks_and_mark_as_closed!
  end

  def open_parent_task_cascade
    list_task.check_subtasks_and_change_my_status! if list_task.present?
    list.check_tasks_and_mark_as_opened!
  end
end
