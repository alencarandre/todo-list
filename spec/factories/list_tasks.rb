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

FactoryBot.define do
  factory :list_task do
    list
    name "Task 1"
    list_task nil
    status :opened
  end
end
