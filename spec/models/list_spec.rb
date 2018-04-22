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
  end

end
