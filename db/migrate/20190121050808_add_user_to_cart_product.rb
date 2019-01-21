class AddUserToCartProduct < ActiveRecord::Migration[5.1]
  def change
    add_reference :cart_products, :user, foreign_key: true
  end
end
