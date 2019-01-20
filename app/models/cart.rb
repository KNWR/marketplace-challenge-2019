# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cart < ApplicationRecord
  has_many :cart_products

  # add product method
  def add(product)
    CartProduct.create(cart: self, product: product)
  end

  # checkout method

  # total price method
  def total_price
    cart_products.inject(0, :+}
  end

  # list all products in cart method
  def list_products
    cart_products.map(&:product)
  end

  # optional remove product


end
