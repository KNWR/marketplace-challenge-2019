# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Cart, type: :model do

  # add a product to the cart
  describe ".add" do
    context "there is enough (>0) inventory of the product" do
      cart = Cart.create

      product = Product.create(title: 'Snowboard',
                            price: 50.20,
                            inventory_count: 10)

      it "adds a product to the cart" do

        cart.add(product)
        expect(cart.list_products[0]).to eq product
      end
    end

    context "the product is out of stock!" do
      cart = Cart.create

      product = Product.create(title: 'Snowboard',
                            price: 50.20,
                            inventory_count: 0)

      it "does not add the product to the cart, passes an error message" do
        expect{cart.add(product)}.to raise_error(StandardError,
          "Darn! That product's currently out of stock. I hope to restock"\
          "it for you soon. - Kanwar"
        )

        expect(cart.list_products).to eq []
      end
    end
  end

  describe ".list_products" do
    it "returns a list of products" do
      cart = Cart.create

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
      cart = Cart.create

      subtotal = 0

      5.times do
        product = Product.create(title: Faker::Commerce.product_name,
                                price: Faker::Commerce.price,
                                inventory_count: Faker::Number.between(1, 10)
                              )
        cart.add(product)
        subtotal += product&.price
      end

      expect(cart.subtotal).to eq subtotal
    end
  end

  describe ".checkout" do
    context "when the products in the cart have enough inventory" do
      cart = Cart.create

      product_inventory = 1

      product = Product.create(title: Faker::Commerce.product_name,
                              price: Faker::Commerce.price,
                              inventory_count: product_inventory
                            )
      cart.add(product)

      it "decreases their inventory & removes products from the cart" do
        cart.checkout

        # TODO why reload
        expect(product.reload.inventory_count).to eq (product_inventory - 1)
        expect(cart.reload.cart_products).to eq []
      end
    end

    context "when a product already added to the cart goes out of inventory" do
      cart = Cart.create

      product = Product.create(title: Faker::Commerce.product_name,
                              price: Faker::Commerce.price,
                              inventory_count: 1
                            )
      cart.add(product)

      # Q: Why wait until after we add the product to the cart to set its inventory
      #     to 0?
      # A: Because we validate against adding on the model.
      #     The situation in this test might occur if two carts (i.e. two users)
      #     add the same product, which is at inventory_count = 1, before either
      #     checks out. Then, after one checks out, inventory_count = 0. Then,
      #     the other cart tries to check out. But there's no inventory left!
      product.inventory_count = 0

      it "returns an error message, leaves the cart unchanged" do # or removes the item of which nothing's left
        cart.checkout

        expect(product.reload.inventory_count).to eq (0)
        expect{cart.checkout}.to raise_error(StandardError,
          "Darn! Looks like someone else just bought the last one!"\
          "I've removed it from your cart for you. I hope to restock it soon! - Kanwar"
        )
      end
    end
  end


end
