# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_carts_on_user_id  (user_id)
#

class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_products

  validates :user, presence: true

  def add(product)
    # To guard against if someone tries to order more of something than we have
    if product.inventory_count > 1
      self.cart_products << CartProduct.create(cart: self, product: product)

    else
      raise "Darn! We have #{product.inventory_count} of #{product.title}. "\
            "Can't sell you more than that. I hope to restock it for you soon. - Kanwar"
    end
  end

  def checkout
    raise "Cart is empty" if cart_products.empty?
    # Array of cart products where amount > inventory
    # Given time, would write this with SQL using .where instead of .select
    # out_of_stock = []
    # cart_products.each do |cp|
    #   out_of_stock.append(cp) if (cp.product.inventory_count < cp.amount)
    # end
    # If there exist such cart_products...
    if out_of_stock.any?
      # Generate our error message before we destroy the cart_products we need
      #    for the message
      error_message = "Darn! Looks like someone just bought the last we had "\
                      "of something(s) in your cart order! None of the items in the carts"\
                      "were purchased. I removed those particular items from your cart,"\
                      "and left the rest of the items in the cart so you can try purchasing"\
                       "again. I hope to restock soon! - Kanwar"
      # And destroy them
      out_of_stock.each {|cp| cp.destroy}
      raise error_message
    # Else there is sufficient amount of products in stock to meet the order
    else
      # For each
      cart_products.each do |cart_product|
        # Lets remove the products from our inventory
        product = cart_product.product
        product.inventory_count -= 1
        product.save
        # And reset the cart's cart_products by destroying the association
        #    using the self.prefix to make this clear
        self.cart_products.delete(cart_product)
        # and transfer them to the purchaser
        cart_product.user = self.user
        self.user.save
        cart_product.save
      end
    end
    self.save
    # self.save
  end

  def subtotal
    subtotal = 0
    cart_products.each do |cp|
      subtotal += cp.product.price
    end
    subtotal
  end

  def list_products
    cart_products.map(&:product) # ruby tuple
  end

end
