
require 'test_helper'
require 'json'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "the truth" do
    sign_in users(:alexandre)
  end

  test 'when a guide is online go to profile guide' do
    get :organizer
    assert_response :success
  end
end
