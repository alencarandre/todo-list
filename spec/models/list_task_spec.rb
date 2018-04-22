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

require 'rails_helper'

RSpec.describe ListTask, type: :model do
  subject { FactoryBot.create(:list_task) }

  describe '#validations' do
    it 'has valid factory' do
      expect(FactoryBot.build(:list_task)).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:list) }
    it { should validate_presence_of(:status) }
  end

  describe '#initialize' do
    it 'gives status :opened by default' do
      task = ListTask.new
      expect(task.status).to eq("opened")
    end
  end

  describe "#status" do
    it 'when set invalid values, raise error' do
      task = ListTask.new

      [:invalid, :value, :foo, :bar].each do |value|
        expect {
          task.status = value
        }.to raise_error(ArgumentError)
      end
    end

    it 'when set valid value, set the value' do
      task = ListTask.new

      [:opened, :closed].each do |value|
        task.status = value
        expect(task.status.to_sym).to eq(value)
      end
    end
  end

  describe '#associations' do
    it { should belong_to(:list) }
    it { should belong_to(:list_task) }
  end
end
