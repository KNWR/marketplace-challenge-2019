# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  context "Validations" do
    it { is_expected.to validate_presence_of(:username) }
  end
end
