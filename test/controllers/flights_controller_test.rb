require 'test_helper'

class FlightsControllerTest < ActionController::TestCase

  setup do
    @nearest_airports = [{
      airport_name: "Burlington International Airport"
    }]
  end

  test "should request to get nearest airports" do
     skip('for now')
     get :nearest_airports, { origin: 'BOS', destination: 'LON', departure_date: '2017-12-25', return_date: '' }
     assert_equal assigns(:nearest_airports)[0]["airport_name"], @nearest_airports[0]["airport_name"]
  end

  test "should request cheap flights" do
    skip('for now')
    get :nearest_airports, { origin: 'BOS', destination: 'LON', departure_date: '2017-12-25', return_date: '' }
    assert_equal assigns(:nearest_airports), @nearest_airports
  end
end
