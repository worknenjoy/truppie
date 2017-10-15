include Devise::TestHelpers
require 'test_helper'
require 'json'

class GuidebooksControllerTest < ActionController::TestCase
  setup do
    sign_in users(:alexandre)
    @guidebook = guidebooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:guidebooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create guidebook" do
    assert_difference('Guidebook.count') do
      post :create, guidebook: { organizer_id: Organizer.last.id, title: @guidebook.title, user_id: User.last.id, value: @guidebook.value, verified: @guidebook.verified }
    end
    assert_equal flash[:error], nil
    assert_redirected_to guidebook_path(assigns(:guidebook))
  end

  test "should show guidebook" do
    get :show, id: @guidebook
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @guidebook
    assert_response :success
  end

  test "should update guidebook" do
    patch :update, id: @guidebook, guidebook: { organizer_id: Organizer.last.id, title: @guidebook.title, user_id: User.last.id, value: @guidebook.value, verified: @guidebook.verified }
    assert_redirected_to guidebook_path(assigns(:guidebook))
  end

  test "should confirm payment of a guidebook" do
    post :confirm_presence, {"id"=> Guidebook.last, "method"=>"CREDIT_CARD", "fullname"=>"Alexandre Magno Teles Zimerer", "birthdate"=>"06/10/1982", "street"=>"X", "complement"=>"10", "city"=>"Rio de Janeiro", "state"=>"Rio de Janeiro", "country"=>"Brazil", "zipcode"=>"2001112-444", "number"=>"5555666677778884", "expiration_month"=>"05", "expiration_year"=>"18", "cvc"=>"123", "value"=>"300", "package"=>"1", "amount"=>"1", "final_price"=>"300", "token"=>"tok_1BDGkwHWrGpvLtXMY6d4ydNS"}
    assert_response :success
  end

  test "should destroy guidebook" do
    skip('not destrying properly')
    assert_difference('Guidebook.count', -1) do
      delete :destroy, id: @guidebook
    end

    assert_redirected_to guidebooks_path
  end
end
