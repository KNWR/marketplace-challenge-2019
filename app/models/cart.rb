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
    if product.inventory_count >= 1
      CartProduct.create(cart: self, product: product)
    else
      #TODO add shoot me an email text for engagement
      puts "Darn! That product's currently out of stock. I hope to restock"\
            "soon for you."
    end
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
        product.save
        cart_product.destroy # TODO
      else
        #TODO ok need to rescue this with graphql
        # maybe shouldn't be error ...
        raise "Darn! Looks like that product is out of stock. I've removed it"\
              "from your cart for you. I hope to restock it soon! - Kanwar"
      end
    end
  end

  def subtotal
    cart_products.joins(:product).sum(:price)
  end

  # list all products in cart method
  def list_products
    cart_products.map(&:product)
  end

end
