include Devise::TestHelpers
require 'test_helper'

class ToursControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true
  
  setup do
    sign_in users(:alexandre)
    @tour = tours(:morro)
  end
  
  #teardown do
    #DatabaseCleaner.clean
  #end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should create tour" do
    # assert_difference('Tour.count') do
      # post :create, tour: {}
    # end
# 
    # assert_redirected_to tour_path(assigns(:tour))
  # end

  test "should show tour" do
    get :show, id: @tour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tour
    assert_response :success
  end

  test "should update tour" do
    patch :update, id: @tour, tour: {  }
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "increment one more member" do
    @tour_confirmed_before = @tour.confirmeds.count
    post :confirm_presence, id: @tour
    @tour_confirmed_after = @tour.confirmeds.count
    assert_equal @tour_confirmed_before + 1, @tour_confirmed_after
  end
  
  test "should confirm presence" do
    post :confirm_presence, id: @tour
    assert_equal 'Presence Confirmed!', flash[:success]
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should not confirm again" do
    post :confirm_presence, id: @tour
    post :confirm_presence, id: @tour
    assert_equal 'Hey, you already confirmed this event!!', flash[:error]
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should not confirm if soldout" do
    @tour.confirmeds.create(user: users(:laura))
    @tour.confirmeds.create(user: users(:fulano))
    @tour.confirmeds.create(user: users(:ciclano))
    post :confirm_presence, id: @tour
    assert_equal 'this event is soldout', flash[:error]
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should unconfirm" do
    @tour.confirmeds.create(user: users(:alexandre))
    assert_equal @tour.available, 2
    post :unconfirm_presence, id: @tour
    assert_equal 'you were successfully unconfirmed to this tour', flash[:success]
    assert_equal @tour.available, 3
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  # test "should destroy tour" do
    # assert_difference('Tour.count', -1) do
      # delete :destroy, id: @tour
    # end
# 
    # assert_redirected_to tours_path
  # end
end
