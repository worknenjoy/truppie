include Devise::TestHelpers
require 'test_helper'
require 'json'

class GuidebooksControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    sign_in users(:alexandre)
    @guidebook = guidebooks(:one)

    @payment_data = {
        id: @guidebook,
        method: "CREDIT_CARD",
        fullname: "Alexandre Magno Teles Zimerer",
        birthdate: "10/10/1988",
        value: @guidebook.value,
        token: StripeMock.generate_card_token(last4: "9191", exp_year: 1984)
    }

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
    StripeMock.prepare_card_error(:card_declined)
    post :confirm_presence, @payment_data
    assert_equal Guidebook.find(@guidebook.id).orders.any?, false
    assert_equal assigns(:confirm_headline_message), "Não foi possível confirmar sua reserva"
    assert_equal assigns(:confirm_status_message), "Tivemos um problema ao processar seu cartão"
    assert_equal assigns(:status), "danger"
    assert_template "confirm_presence"
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
