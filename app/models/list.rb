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
  has_many :list_tasks

  STATUS_VALUES = [:opened, :closed]
  ACCESS_TYPE_VALUES = [:shared, :personal]

  enum status: STATUS_VALUES
  enum access_type: ACCESS_TYPE_VALUES

  validates :name, presence: true
  validates :user, presence: true
  validates :access_type, presence: true
  validates :status, presence: true

  scope :by_user, -> (user) { where(user: user) }
  scope :order_created_at_desc, -> { order("created_at DESC") }

  def initialize(attrs = {})
    super
    self.status ||= :opened
  end

end
