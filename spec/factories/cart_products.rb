# == Schema Information
#
# Table name: cart_products
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cart_id    :integer
#  product_id :integer
#
# Indexes
#
#  index_cart_products_on_cart_id     (cart_id)
#  index_cart_products_on_product_id  (product_id)
#

FactoryBot.define do
  factory :cart_product do
    cart { nil }
    product { nil }
  end
end
