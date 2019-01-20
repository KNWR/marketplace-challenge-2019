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

require 'rails_helper'

RSpec.describe Product, type: :model do

  context "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:inventory_count) }
  end

end
