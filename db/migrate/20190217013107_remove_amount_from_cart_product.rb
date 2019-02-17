class RemoveAmountFromCartProduct < ActiveRecord::Migration[5.1]
  def change
    remove_column :cart_products, :amount, :integer
  end
end
