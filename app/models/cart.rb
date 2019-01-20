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

  # remove method
  # def remove(product)
  # find cart product given product and cart
  # delete it
  # end

  # checkout method
  def checkout
    cart_products.each do |cart_product|
      product = cart_product.product
      if product.inventory_count > 0
        product.inventory_count -= 1
        product.save # TODO why
        cart_product.destroy
      else
        #TODO depending on resolve in graphql should do here though
        raise "Darn! Looks like that product is out of stock. I've removed"\
              "it from your cart. Sorry about this."
      end
    end
    # for each of the cart's cart_products
      # if its :product's inventory >0
        # decrement it
        # destroy the cart_product
      # otherwise
        # return an error message -- no more of that product left in stock
        # what happens then?
  end
  # total price method
  # or name subtotal?
  def total_price
    cart_products.joins(:product).sum(:price)
  end

  # list all products in cart method
  def list_products
    cart_products.map(&:product)
  end

end
