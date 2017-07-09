require 'test_helper'

class RailsGirlTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:message)
  # test "the truth" do
  #   assert true
  # end
end
