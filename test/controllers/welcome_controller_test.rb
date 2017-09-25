include Devise::TestHelpers
require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase


  test "the truth" do
    skip("setup auth")
     get :organizer
     assert_response :success
  end
end
