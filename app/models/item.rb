class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :orders, through: :order_details

  

  validates :name, presence: true
  validates :description, presence: true
end
