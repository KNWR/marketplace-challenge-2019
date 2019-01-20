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
  validates :inventory_count, presence: true
  validates :price, presence: true
end

#TODO validate is >= 0, -- likely will require numericality?
