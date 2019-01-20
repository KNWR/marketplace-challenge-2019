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

  describe ".method" do
    it "behaviour" do
    end
  end

  # add a product to the cart

  # remove a product from the cart

  # try adding a product when there's 0 left of it

  # what happens when two carts add the same product, one checks out, then the other one does?

  # oh ... should be able to checkout the cart ... does that
    # delete the cart? or reset it?
    # checking the product inventory amount has accordingly decremented

  # list the products in the cart ## method

  # list the total value of the cart

  #

  context "" do
  end

  context "" do
  end

  context "" do
  end

end
