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
end