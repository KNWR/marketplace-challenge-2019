# == Schema Information
#
# Table name: cart_products
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cart_id    :integer
#  product_id :integer
#  user_id    :integer
#
# Indexes
#
#  index_cart_products_on_cart_id     (cart_id)
#  index_cart_products_on_product_id  (product_id)
#  index_cart_products_on_user_id     (user_id)
#

class CartProduct < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  belongs_to :user, optional: true

  validates :cart, presence: true, on: :create
  validates :product, presence: true
end
