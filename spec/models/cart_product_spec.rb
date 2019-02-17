# == Schema Information
#
# Table name: cart_products
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cart_id    :integer
#  product_id :integer
#  user_id    :integer
#
# Indexes
#
#  index_cart_products_on_cart_id     (cart_id)
#  index_cart_products_on_product_id  (product_id)
#  index_cart_products_on_user_id     (user_id)
#

require 'rails_helper'

RSpec.describe CartProduct, type: :model do

  context "Validations" do
    # it { is_expected.to validate_presence_of(:cart) }
    it { is_expected.to validate_presence_of(:product) }
  end

end
