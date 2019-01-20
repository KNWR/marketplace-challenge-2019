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
  cart = Cart.create # or new?

  # add a product to the cart
  describe ".add" do
    it "adds a product to the cart" do
      product = Product.create(title: 'Snowboard',
                            price: 50.20,
                            inventory_count: 10)
      cart.add(product)
      expect(cart.list_products[0]).to eq product
    end
  end

end
