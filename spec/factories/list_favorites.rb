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

FactoryBot.define do
  factory :list_favorite do
    list
    user
  end
end
