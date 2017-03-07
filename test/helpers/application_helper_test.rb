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
    assert_equal "R$ 20,00", friendly_price(price)
  end
  
  test "should return the price friendly when 0" do
    price = 0
    assert_equal "R$ 0", friendly_price(price)
  end
  
  test "should return the final price formatted" do
    price = 40
    assert_equal "<small>R$</small><span>40</span>", final_price(price)
  end
  
  test "should return raw price" do
    price = "20,00"
    assert_equal 2000, raw_price(price)
  end
  
   test "should return raw price when price without unit" do
    price = "20"
    assert_equal 2000, raw_price(price)
  end
  
  test "should return raw price when tiven price" do
    price = "34,20"
    assert_equal 3420, raw_price(price)
  end
  
  test "should display the transfer status" do
    status = "REQUESTED"
    assert_equal "Solicitado", transfer_status(status)
  end
  
  test "should display the transfer status when completed" do
    status = "COMPLETED"
    assert_equal "Completado", transfer_status(status)
  end
  
  test "should display the transfer status when failed" do
    status = "FAILED"
    assert_equal "Falhou", transfer_status(status)
  end
  
  test "should convert user image to https" do
    assert_equal "https://www.truppie.com", to_https("http://www.truppie.com")
    
  end
  
end