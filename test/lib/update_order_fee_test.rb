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
    
    it_was_updated_by_redis = []
    
    puts Order.all.where(:status => "AUTHORIZED").count
      
    puts Order.all.where(:status => "SETTLED").count
    
    assert_equal orders.contains?(it_was_updated_by_redis)     
  end

end