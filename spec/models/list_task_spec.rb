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

    context 'when pass parent task' do
      context 'when list_task belongs to other list' do
        it 'gives invalid' do
          other_list = FactoryBot.create(:list)
          parent_task = FactoryBot.create(:list_task, list: other_list)

          subject.list_task = parent_task
          expect(subject).to_not be_valid
        end
      end

      context 'when list_task belongs to some list' do
        it 'gives valid' do
          parent_task = FactoryBot.create(:list_task, list: subject.list)

          subject.list_task = parent_task
          expect(subject).to be_valid
        end
      end
    end
  end

  describe '#initialize' do
    context 'when not have parent task' do
      it 'gives status :opened by default' do
        task = ListTask.new
        expect(task).to be_opened
      end
    end

    context 'when has parent task' do
      it 'gives status == parent status by default' do
        [:opened, :closed].each do |status|
          task = FactoryBot.create(:list_task, status: status)
          sub_task = ListTask.new(list_task: task)

          expect(sub_task.status).to eq(task.status)
        end
      end
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
    it { should have_many(:list_tasks) }
  end

  describe '#scopes' do
    let(:parent_task) { FactoryBot.create(:list_task) }
    let!(:task) { FactoryBot.create(:list_task,
                                    list: parent_task.list,
                                    list_task: parent_task) }

    it '.main_tasks' do
      expect(ListTask.main_tasks.pluck(:id)).to eq([parent_task.id])
    end
  end

  describe '#destroy' do
    let(:parent_task) { FactoryBot.create(:list_task) }
    let!(:task) { FactoryBot.create(:list_task,
                              list: parent_task.list,
                              list_task: parent_task) }

    it 'when task is destroyed, destroy sub tasks as well' do
      parent_task.destroy

      expect(ListTask.where(id: task.id).first).to be_blank
    end
  end


  describe '#status' do
    context 'when change status to closed' do
      let(:task) { FactoryBot.create(:list_task) }
      let!(:sub_task) { FactoryBot.create(:list_task,
                                          list: task.list,
                                          status: :opened,
                                          list_task: task) }
      let!(:sub_sub_task) { FactoryBot.create(:list_task,
                                              list: sub_task.list,
                                              status: :opened,
                                              list_task: sub_task) }
      it 'close all sub tasks on cascade' do
        task.closed!

        sub_task.reload
        sub_sub_task.reload

        expect(sub_task).to be_closed
        expect(sub_sub_task).to be_closed
      end
    end

    context 'when all sub tasks is closed and try to open' do
      let(:task) { FactoryBot.create(:list_task, status: :closed) }
      let!(:sub_task) { FactoryBot.create(:list_task,
                                          list: task.list,
                                          status: :closed,
                                          list_task: task) }
      let!(:sub_sub_task) { FactoryBot.create(:list_task,
                                              list: sub_task.list,
                                              status: :closed,
                                              list_task: sub_task) }

      it 'not open task' do
        task.reload
        task.opened!

        expect(task).to be_closed
      end
    end

    context 'when change sub task status' do
      let(:task) { FactoryBot.create(:list_task) }
      let!(:sub_task_1) { FactoryBot.create(:list_task,
                                            list: task.list,
                                            status: :opened,
                                            list_task: task) }
      let!(:sub_task_2) { FactoryBot.create(:list_task,
                                            list: task.list,
                                            status: :opened,
                                            list_task: task) }

      it 'when all sub tasks is closed changes parent to closed' do
        sub_task_1.closed!
        sub_task_2.closed!

        task.reload

        expect(task).to be_closed
      end

      it 'when at least one sub task is open, changes parent to opened' do
        task = FactoryBot.create(:list_task, status: :closed)
        sub_task_1 = FactoryBot.create(:list_task,
                                        list: task.list,
                                        status: :closed,
                                        list_task: task)
        sub_task_2 = FactoryBot.create(:list_task,
                                        list: task.list,
                                        status: :closed,
                                        list_task: task)


        ListTask.find(sub_task_2.id).opened!
        expect(ListTask.find(task.id)).to be_opened
      end

      it 'when close some level, it is supposed to closed parents until first level' do
        task = FactoryBot.create(:list_task, status: :opened)
        sub_task = FactoryBot.create(:list_task,
                                      list: task.list,
                                      status: :opened,
                                      list_task: task)
        sub_sub_task = FactoryBot.create(:list_task,
                                          list: sub_task.list,
                                          status: :opened,
                                          list_task: sub_task)
        sub_sub_sub_task = FactoryBot.create(:list_task,
                                            list: sub_sub_task.list,
                                            status: :opened,
                                            list_task: sub_sub_task)
        sub_sub_sub_task.closed!

        expect(ListTask.find(task.id)).to be_closed
        expect(ListTask.find(sub_task.id)).to be_closed
        expect(ListTask.find(sub_task.id)).to be_closed

      end
    end

    context 'when close some task and have other opened tasks' do
      it 'keep other tasks and list opened' do
        list = FactoryBot.create(:list, status: :opened)
        task1 = FactoryBot.create(:list_task, status: :opened, list: list)
        task2 = FactoryBot.create(:list_task,
                                        list: list,
                                        status: :opened)

        task2.closed!

        expect(List.find(list.id)).to be_opened
        expect(ListTask.find(task1.id)).to be_opened
      end
    end
  end
end
