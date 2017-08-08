include Devise::TestHelpers
require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase


  test "the truth" do
     get :organizer
     assert_response :success
  end
end
