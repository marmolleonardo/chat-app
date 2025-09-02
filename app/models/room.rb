class Room < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :user_rooms
  has_many :users, through: :user_rooms
end
