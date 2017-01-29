require 'test_helper'

class UpdateOrderFeeTest < ActiveSupport::TestCase
  setup do
    Member.first.update_attribute(:membership_type, 4)
    Member.last.update_attribute(:membership_type, 5)
        
    Truppie::Application.load_tasks
    Rake::Task['truppie:update_order_fee'].invoke
  end

  test "update order fee" do
    
    orders = []
    
    Order.all  
    
    assert_equal Member.first.membership_type, "member"     
  end

end