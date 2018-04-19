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

class List < ApplicationRecord
  belongs_to :user

  enum status: [:opened, :closed]
  enum access_type: [:shared, :personal]

  validates :name, presence: true
  validates :user, presence: true
  validates :access_type, presence: true
  validates :status, presence: true

  scope :by_user, -> (user) { where(user: user) }

  def initialize(attrs = {})
    super

    self.status ||= :opened
  end
end
