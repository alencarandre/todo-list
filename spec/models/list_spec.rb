# == Schema Information
#
# Table name: lists
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  user_id     :integer          not null
#  access_type :string           not null
#  status      :string           not null
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

  describe "#status=" do
    it 'when set invalid values, set nil' do
      list = List.new

      [:invalid, :value, :foo, :bar].each do |value|
        expect {
          list.status = value
        }.to raise_error(ArgumentError)
        # expect(list.status).to be_nil
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
    it 'when set invalid values, set nil' do
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
end
