require 'test_helper'
require 'application_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper
 
  test "should return a hash with status of error" do
    assert_equal flash_status('error'), {:className => 'danger', :label => 'ops!'}
  end
  
  test "should return a hash with status of success" do
    assert_equal flash_status('success'), {:className => 'success', :label => 'oba!'}
  end
  
  test "should return the time ago or time left to a date" do
    time = Time.now - 15.hours
    assert_equal "aproximadamente 15 horas atrás", friendly_when(time)
  end
  
  test "should return the time ago or time before a date" do
    time = Time.now + 20.hours
    assert_equal "daqui a aproximadamente 20 horas", friendly_when(time)
  end
  
  test "should return the price friendly" do
    price = 2000
    assert_equal "R$ 2,00", friendly_price(price)
  end
  
  test "should return the price friendly when 0" do
    price = 0
    assert_equal "R$ 0", friendly_price(price)
  end
  
  test "should return the final price formatted" do
    price = 40
    assert_equal "<small>R$</small> <span>40</span>", final_price(price)
  end
  
end