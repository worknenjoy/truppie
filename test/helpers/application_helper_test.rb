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
  
end