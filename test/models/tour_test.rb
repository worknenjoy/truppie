require 'test_helper'

class TourTest < ActiveSupport::TestCase
  test "one tour created" do
     assert_equal 1, Tour.count
   end
end
