require 'test_helper'

class TourTest < ActiveSupport::TestCase
  test "two fixtures" do
     assert_equal 2, WebSite.count
   end
end
