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

  def add(product)
    if product.inventory_count >= 1
      CartProduct.create(cart: self, product: product)
    else
      #TODO rescue w GraphQL
      raise "Darn! That product's currently out of stock. I hope to restock"\
            "it for you soon. - Kanwar"
    end
  end

  def checkout
    cart_products.each do |cart_product|
      product = cart_product.product
      if product.inventory_count > 0
        product.inventory_count -= 1
        product.save
        # In an actual e-commerce system, we'd want to just remove the cart_product
        # association with the cart but not destory it. We'd keep track of the
        # product and want associated data. We're not done with it at *least*
        # until after the customer's happy with it.
        cart_product.destroy
      else
        #TODO rescue w GraphQL
        raise "Darn! Looks like someone else just bought the last one!"\
              "I've removed it from your cart for you. I hope to restock it soon! - Kanwar"
      end
    end
  end

  def subtotal
    cart_products.joins(:product).sum(:price)
  end

  def list_products
    cart_products.map(&:product)
  end

end
