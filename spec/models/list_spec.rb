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

require 'rails_helper'

RSpec.describe List, type: :model do
  subject { FactoryBot.create(:list) }

  describe '#validations' do
    it 'has valid factory' do
      expect(FactoryBot.build(:list)).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:access_type) }
    it { should validate_presence_of(:status) }
  end

  describe '#associations' do
    it { should belong_to(:user) }
    it { should have_many(:list_tasks) }
    it { should have_many(:list_favorites) }
  end

  describe "#initialize" do
    it 'set status = :opened by default' do
      list = List.new
      expect(list.status.to_sym).to eq(:opened)
    end

    it 'let set other values valid in status' do
      list = List.new(status: :closed)
      expect(list.status.to_sym).to eq(:closed)
    end
  end

  describe "#status=" do
    it 'when set invalid values, raise error' do
      list = List.new

      [:invalid, :value, :foo, :bar].each do |value|
        expect {
          list.status = value
        }.to raise_error(ArgumentError)
      end
    end

    it 'when set valid value, set the value' do
      list = List.new

      [:opened, :closed].each do |value|
        list.status = value
        expect(list.status.to_sym).to eq(value)
      end
    end
  end

  describe "#access_type=" do
    it 'when set invalid values, raise error' do
      list = List.new

      [:invalid, :value, :foo, :bar].each do |value|
        expect {
          list.status = value
        }.to raise_error(ArgumentError)
      end
    end

    it 'when set valid value, set the value' do
      list = List.new

      [:shared, :personal].each do |value|
        list.access_type = value
        expect(list.access_type.to_sym).to eq(value)
      end
    end
  end

  describe ".scopes" do
    it '.by_user' do
      user = FactoryBot.create(:user)
      another_user = FactoryBot.create(:user)

      list_1 = FactoryBot.create(:list, name: "List 1", user: another_user)
      list_2 = FactoryBot.create(:list, name: "List 2", user: user)

      lists = List.by_user(user).all
      list = lists.first

      expect(lists.count).to eq(1)
      expect(list.id).to eq(list_2.id)
      expect(list.name).to eq(list_2.name)
      expect(list.user.id).to eq(list_2.user.id)
    end

    it '.order_created_at_desc' do
      list_1 = FactoryBot.create(:list, name: "List 1")
      list_2 = FactoryBot.create(:list, name: "List 2")

      lists = List.order_created_at_desc.pluck(:name)

      expect(lists).to eq(['List 2', 'List 1'])
    end

    it '.shared_lists' do
      list_1 = FactoryBot.create(:list, name: "List 1", access_type: :shared)
      list_2 = FactoryBot.create(:list, name: "List 2", access_type: :personal)

      lists = List.shared_lists.pluck(:name)

      expect(lists).to eq(['List 1'])
    end
  end

  describe '#status' do
    context 'when mark status as closed' do
      it 'mark all tasks as closed' do
        list = FactoryBot.create(:list, status: :opened)
        sub_task_1 = FactoryBot.create(:list_task, status: :opened, list: list)
        sub_task_2 = FactoryBot.create(:list_task, status: :opened, list: list)
        sub_sub_task = FactoryBot.create(:list_task,
                                          status: :opened,
                                          list: list,
                                          list_task: sub_task_2)

        list.closed!

        list.list_tasks.all.each { |task| expect(task).to be_closed }
      end
    end

    context 'when all tasks is closed and try to open' do
      let(:list) { FactoryBot.create(:list, status: :closed) }
      let(:task) { FactoryBot.create(:list_task, status: :closed, list: list) }
      let!(:sub_task) { FactoryBot.create(:list_task,
                                          list: task.list,
                                          status: :closed,
                                          list_task: task) }
      let!(:sub_sub_task) { FactoryBot.create(:list_task,
                                              list: sub_task.list,
                                              status: :closed,
                                              list_task: sub_task) }

      it 'not open task' do
        list.reload
        list.opened!

        expect(list).to be_closed
      end
    end

    it 'when mark some list as closed, do not change other lists' do
      list = FactoryBot.create(:list, status: :opened)
      sub_task_1 = FactoryBot.create(:list_task, status: :opened, list: list)
      sub_task_2 = FactoryBot.create(:list_task, status: :opened, list: list)
      sub_sub_task = FactoryBot.create(:list_task,
                                        status: :opened,
                                        list: list,
                                        list_task: sub_task_2)

      other_list = FactoryBot.create(:list, status: :opened)
      other_sub_task_1 = FactoryBot.create(:list_task, status: :opened, list: other_list)
      other_sub_task_2 = FactoryBot.create(:list_task, status: :opened, list: other_list)
      other_sub_sub_task = FactoryBot.create(:list_task,
                                        status: :opened,
                                        list: other_list,
                                        list_task: other_sub_task_2)

      list.closed!

      list.list_tasks.all.each { |task| expect(task).to be_closed }
      other_list.list_tasks.all.each { |task| expect(task).to be_opened }
    end

    context 'when mark status as opened' do
      context 'when change sub task' do
        it 'when at least one task status is opened mark list status opened' do
          list = FactoryBot.create(:list, status: :closed)
          task_1 = FactoryBot.create(:list_task, status: :closed, list: list)
          task_2 = FactoryBot.create(:list_task, status: :closed, list: list)
          sub_task = FactoryBot.create(:list_task,
                                            status: :closed,
                                            list: list,
                                            list_task: task_2)

          sub_task.opened!

          list.reload

          expect(list).to be_opened
        end
      end

      context 'when change task' do
        it 'when at least one task status is opened mark list status opened' do
          list = FactoryBot.create(:list, status: :closed)
          task_1 = FactoryBot.create(:list_task, status: :closed, list: list)

          task_1.opened!

          list.reload

          expect(list).to be_opened
        end
      end
    end
  end

end
