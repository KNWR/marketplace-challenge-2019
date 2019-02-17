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
      # cart_products << # note to self -- not needed to create the association!
        # the below line automatically creates the association, as it lives on
        # the cart_product table -- t.index ["cart_id"], name: "index_cart_products_on_cart_id"
      CartProduct.create(cart: self, product: product)
    else
      raise "Darn! We have #{product.inventory_count} of #{product.title}. "\
            "Can't sell you more than that. I hope to restock it for you soon. - Kanwar"
    end
  end

  def checkout
    raise "Cart is empty" if cart_products.empty?
    # Array of cart products we have out of stock
    out_of_stock = []
    cart_products.each do |cp|
      out_of_stock.append(cp) if (cp.product.inventory_count < 1)
    end
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
      out_of_stock.each {|cp| CartProduct.find(cp.id).destroy}
      raise error_message
    # # Else there is sufficient amount of products in stock to meet the order
    else
      # For each
      # ALT to below: until self.cart_products.empty? do |cart_product|
      self.cart_products.each do |cart_product|
        # this line fixed the method - previously would skip some of the items
        # https://stackoverflow.com/questions/22259641/why-use-reload-method-after-saving-object-hartl-rails-tut-6-30
        # https://stackoverflow.com/questions/16477739/rubys-each-methods-not-iterating-over-all-items-in-an-array -- alt
        # probably inefficient?
        cart_products.reload
        # Lets remove the products from our inventory
        product = cart_product.product
        product.inventory_count -= 1
        # product.save
        # cp them to the purchaser
        cart_product.user = self.user
        # And reset the cart's cart_products by destroying the association
        cart_products.delete(cart_product)
      end
    end
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
