require 'test_helper'

class OrderTaskTest < ActiveSupport::TestCase
  test "update order fee" do
    skip("migrate to stripe")
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = false
    
    body_for_order = {
      :status => "AUTHORIZED",
      :amount => {
        :fees => 10,    
        :liquid => 20,
        :total => 30 
      }
    }
    FakeWeb.register_uri(:get, %r|sandbox.moip.com.br/v2/payments|, :body => body_for_order.to_json, :status => ["200", "Success"])
    
    Truppie::Application.load_tasks
    Rake::Task['truppie:update_order_fee'].invoke
    
    orders = Order.all.count
    
    it_was_updated_by_redis = []
    
    Order.all.each do |o|
      slug = o.to_param
      redis_key = $redis.get(slug)
      if not redis_key.nil?
        it_was_updated_by_redis.push(o)
      end 
    end
    
    puts Order.all.where(:status => "AUTHORIZED").count
      
    puts Order.all.where(:status => "SETTLED").count
    
    assert_equal orders, it_was_updated_by_redis.size     
  end

end