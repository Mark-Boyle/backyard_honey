class Product < ApplicationRecord
  belongs_to :user
  has_one_attached :picture
  has_many :orders
  validates :name, :price, :location, :description, :size, presence: true
end
