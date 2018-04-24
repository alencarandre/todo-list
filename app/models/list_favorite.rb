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

class ListFavorite < ApplicationRecord
  belongs_to :list
  belongs_to :user

  validates :list, presence: true
  validates :user, presence: true
end
