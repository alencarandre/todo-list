# == Schema Information
#
# Table name: list_favorites
#
#  id         :integer          not null, primary key
#  list_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ListFavorite, type: :model do
  subject { FactoryBot.build(:list_favorite) }

  describe '#validations' do
    it 'has valid factory' do
      expect(FactoryBot.build(:list_favorite)).to be_valid
    end

    it { should validate_presence_of(:list) }
    it { should validate_presence_of(:user) }
  end

  describe '#associations' do
    it { should belong_to(:list) }
    it { should belong_to(:user) }
  end
end
