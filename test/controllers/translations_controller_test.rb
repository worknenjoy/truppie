require 'test_helper'

class TranslationsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:alexandre)
  end
  test "should get index" do
    get :index
    assert_response :success
  end

end
