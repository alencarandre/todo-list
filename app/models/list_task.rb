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

  STATUS_VALUES = [:opened, :closed]

  enum status: STATUS_VALUES

  validates :name, presence: true
  validates :list, presence: true
  validates :status, presence: true

  def initialize(attrs = {})
    super(attrs)
    self.status ||= :opened
  end
end
