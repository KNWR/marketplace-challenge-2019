# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  inventory_count :integer
#  price           :decimal(12, 2)
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Product < ApplicationRecord
  validates :title, presence: true
  validates :inventory_count, presence: true,
                              numericality: {greater_than_or_equal_to: 0}
  validates :price, presence: true,
                    numericality: {greater_than_or_equal_to: 0}
end
