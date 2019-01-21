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

require 'rails_helper'

RSpec.describe Cart, type: :model do

  # add a product to the cart
  describe ".add" do
    context "there is enough (>0) inventory of the product" do
      user = User.create(username: 'TobiasLutke')
      cart = Cart.create(user: user)

      product = Product.create(title: "#{Faker::Commerce.product_name} Snowboard",
                            price: 50.20,
                            inventory_count: 10
                          )

      it "adds a product to the cart" do

        cart.add(product)
        expect(cart.list_products.last).to eq product
      end
    end

    context "the product is out of stock!" do
      user = User.create(username: 'DanielWeinand')
      cart = Cart.create(user: user)

      product = Product.create(title: 'Blue Snowboard',
                            price: 50.20,
                            inventory_count: 0
                          )

      it "does not add the product to the cart, passes an error message" do
        expect{cart.add(product)}.to raise_error(StandardError,
          "Darn! We have #{product.inventory_count} of #{product.title}. "\
          "Can't sell you more than that. I hope to restock it for you soon. - Kanwar"
        )

        expect(cart.list_products).to eq []
      end
    end
  end

  describe ".list_products" do
    it "returns a list of products" do
      user = User.create(username: 'ScottLake')
      cart = Cart.create(user: user)

      products_added = []

      5.times do
        product = Product.create(title: Faker::Commerce.product_name,
                                price: Faker::Commerce.price,
                                inventory_count: Faker::Number.between(1, 10)
                              )
        cart.add(product)
        products_added.append product
      end

      expect(cart.list_products).to eq products_added
    end
  end

  describe ".subtotal" do
    it "returns a the total price of products in the cart" do
      user = User.create(username: 'Tobias')
      cart = Cart.create(user: user)

      subtotal = 0

      5.times do
        product = Product.create(title: Faker::Commerce.product_name,
                                price: Faker::Commerce.price,
                                inventory_count: Faker::Number.between(2, 10)
                              )
        cart.add(product, 2)
        subtotal += product.price * 2
      end

      expect(cart.subtotal).to eq subtotal
    end
  end

  describe ".checkout" do
    context "when the products in the cart have enough inventory" do
      user = User.create(username: 'Mahasamatman')
      cart = Cart.create(user: user)

      product_inventory = 1

      product = Product.create(title: Faker::Commerce.product_name,
                              price: Faker::Commerce.price,
                              inventory_count: product_inventory
                            )
      cart.add(product)

      it "decreases their inventory & removes products from the cart" do
        cart.checkout

        expect(product.reload.inventory_count).to eq (product_inventory - 1)
        expect(user.cart_products.first.product).to eq product
      end
    end

    context "when a product already added to the cart goes out of inventory" do
      user = User.create(username: 'Ignatius J Reilly')
      cart = Cart.create(user: user)

      # Q: Why wait until after we add the product to the cart to set its inventory
      #     to 0?
      # A: Because we validate against adding on the model.
      #     The situation in this test might occur if two carts (i.e. two users)
      #     add the same product, which is at inventory_count = 1, before either
      #     checks out. Then, after one checks out, inventory_count = 0. Then,
      #     the other cart tries to check out. But there's no inventory left!

      it "returns an error message, removes out of stock items, inventories untouched" do

        product = Product.create(title: "Everard's #{Faker::Commerce.product_name}",
                                price: Faker::Commerce.price,
                                inventory_count: 1
                              )
        cart.add(product)

        product.inventory_count = 0
        product.save

        expected_error_message = "Darn! Looks like someone just bought the last we had "\
                  "of something(s) in your cart order! None of the items in the carts"\
                  "were purchased. I removed those particular items from your cart,"\
                  "and left the rest of the items in the cart so you can try purchasing"\
                  "again. I hope to restock soon! - Kanwar"
        expect{cart.checkout}.to raise_error(StandardError, expected_error_message)
        expect(product.inventory_count).to eq 0
      end
    end
  end


end
