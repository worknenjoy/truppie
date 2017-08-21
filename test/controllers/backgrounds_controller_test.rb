require 'test_helper'

class BackgroundsControllerTest < ActionController::TestCase
  setup do
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
    assert_difference('Background.count') do
      post :create, background: { name: @background.name, paperclip: @background.paperclip }
    end

    assert_redirected_to background_path(assigns(:background))
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
    patch :update, id: @background, background: { name: @background.name, paperclip: @background.paperclip }
    assert_redirected_to background_path(assigns(:background))
  end

  test "should destroy background" do
    assert_difference('Background.count', -1) do
      delete :destroy, id: @background
    end

    assert_redirected_to backgrounds_path
  end
end
