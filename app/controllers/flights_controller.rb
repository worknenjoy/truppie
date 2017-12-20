class FlightsController < ApplicationController


  def nearest_airports
    @nearest_airports = RestClient.get "https://api.sandbox.amadeus.com/v1.2/airports/nearest-relevant??apikey=#{Rails.application.secrets[:amadeus_api_key]}&latitude=46.6734&longitude=-71.7412"
    @nearest_airports_json = JSON.load @nearest_airports
    render json: @nearest_airports_json
  end

  def cheap_flights
    #@nearest_airports = RestClient.get "https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=#{Rails.application.secrets[:amadeus_api_key]}&origin=BOS&destination=LON&departure_date=2017-12-25&currency=BRL&number_of_results=1"
    #@nearest_airports_json = JSON.load @nearest_airports
    #render json: @nearest_airports_json
  end

end
