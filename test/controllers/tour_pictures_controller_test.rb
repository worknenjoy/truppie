require 'test_helper'

class TourPicturesControllerTest < ActionController::TestCase
  setup do
    @tour_picture = tour_pictures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tour_pictures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tour_picture" do
    assert_difference('TourPicture.count') do
      post :create, tour_picture: { photo: @tour_picture.photo, tour_id: @tour_picture.tour_id }
    end

    assert_redirected_to tour_picture_path(assigns(:tour_picture))
  end

  test "should show tour_picture" do
    get :show, id: @tour_picture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tour_picture
    assert_response :success
  end

  test "should update tour_picture" do
    patch :update, id: @tour_picture, tour_picture: { photo: @tour_picture.photo, tour_id: @tour_picture.tour_id }
    assert_redirected_to tour_picture_path(assigns(:tour_picture))
  end

  test "should destroy tour_picture" do
    assert_difference('TourPicture.count', -1) do
      delete :destroy, id: @tour_picture
    end

    assert_redirected_to tour_pictures_path
  end
end
