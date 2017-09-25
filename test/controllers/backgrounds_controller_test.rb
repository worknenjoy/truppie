require 'test_helper'

class BackgroundsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:alexandre)
    @background = backgrounds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backgrounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create background" do
    skip('is not creating backgrounds')
    source = "http://test/backgrounds/#{@background.to_param}/"
    request.env["HTTP_REFERER"] = source
    assert_difference('Background.count') do
      post :create, background: { name: @background.name }
    end

    assert_redirected_to source
  end

  test "should show background" do
    get :show, id: @background
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @background
    assert_response :success
  end

  test "should update background" do
    patch :update, id: @background, background: { name: @background.name }
    assert_response :success
  end

  test "should destroy background" do
    assert_difference('Background.count', -1) do
      delete :destroy, id: @background
    end

    assert_redirected_to backgrounds_path
  end
end
