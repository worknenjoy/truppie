require 'test_helper'
require 'json'

class TourTest < ActiveSupport::TestCase
  test "one tour created" do
     assert_equal 1, Tour.count
   end
   
   test "a user that create the tour" do
     assert_equal 'laurinha@email.com', Tour.last.user.email
   end
   
   test "a organizer for the tour" do
     assert_equal "Utopicos Mundo Afora", Tour.last.organizer.name
   end
   
   test "the right place for the tour" do
     assert_equal "Rio", Tour.last.where.name
   end
   
   test "one category" do
     assert_equal "Trekking", Tour.last.category.name
   end
   
   test "many tags" do
     assert_equal 3, Tour.last.tags.size
   end
   
   test "many attractions" do
     assert_equal 2, Tour.last.attractions.size
   end
   
   test "confirmed" do
     assert_equal 0, Tour.last.confirmeds.size
   end
   
   test "confirmed availability soldout for infinite availability" do
     assert_equal 0, Tour.last.confirmeds.size
     assert_equal false, Tour.last.soldout?
   end
   
   test "confirmed availability number" do
     Tour.last.confirmeds.create(user: User.last)
     assert_equal 2, Tour.last.available
   end
   
   test "confirmed availability soldout still possible" do
     Tour.last.confirmeds.create(user: users(:laura))
     Tour.last.confirmeds.create(user: users(:alexandre))
     assert_equal false, Tour.last.soldout?
   end
   
   test "confirmed availability soldout not possible" do
     Tour.last.confirmeds.create(user: users(:laura))
     Tour.last.confirmeds.create(user: users(:alexandre))
     Tour.last.confirmeds.create(user: users(:fulano))
     Tour.last.confirmeds.create(user: users(:ciclano))
     assert_equal true, Tour.last.soldout?
   end
   
   test "languages" do
     assert_equal 2, Tour.last.languages.size
   end
   
   test "reviews" do
     assert_equal 2, Tour.last.reviews.size
   end
   
   test "friendly duration" do
      assert_equal "3 minutos", Tour.last.duration
   end
   
   test "a friendly duration more accurated test" do
     Tour.last.update_attribute(:start, '2016-03-01 23:56:31')
     Tour.last.update_attribute(:end, '2018-03-01 23:56:31')
     assert_equal "aproximadamente 2 anos", Tour.last.duration
   end
   
   test "a tour friendly difficult measure" do
     easytour = Tour.last.level
     assert_equal "fácil", easytour
   end
   
   test "a price in real" do
     price = Tour.last.price
     assert_equal "<small>R$</small> 40", price
   end
   
   test "simple payment call" do
     skip("calling moip sandbox several times")
     auth = Moip2::Auth::Basic.new(Rails.application.secrets[:moip_token], Rails.application.secrets[:moip_key])
     client = Moip2::Client.new(:sandbox, auth)
     api = Moip2::Api.new(client)
     order = api.order.create(
          {
              own_id: "ruby_sdk_1",
              items: [
                {
                  product: "Nome do produto",
                  quantity: 1,
                  detail: "Mais info...",
                  price: 1000
                }
              ],
              customer: {
                own_id: "ruby_sdk_customer_1",
                fullname: "Jose da Silva",
                email: "sandbox_v2_1401147277@email.com",
              }
          }
      )
     payment = api.payment.create(order.id,
          {
              installment_count: 1,
              funding_instrument: {
                  method: "CREDIT_CARD",
                  credit_card: {
                      expiration_month: 04,
                      expiration_year: 18,
                      number: "4012001038443335",
                      cvc: "123",
                      holder: {
                          fullname: "Jose Portador da Silva",
                          birthdate: "1988-10-10",
                          tax_document: {
                              type: "CPF",
                              number: "22222222222"
                      },
                          phone: {
                              country_code: "55",
                              area_code: "11",
                              number: "55667788"
                          }
                      }
                  }
              }
          }
      )
      assert_equal payment[:events][1][:type], "PAYMENT.CREATED"
      assert_equal payment.success?, true
   end
   
   test "create a webhook to moip" do
      skip("a webhook to moip avoided")
      headers = {
        :content_type => 'application/json',
        :authorization => Rails.application.secrets[:moip_auth]
      }
      
      receive_url = "http://localhost:3000/webhook"
      
      post_params = {
        events: [
          "ORDER.*",
          "PAYMENT.AUTHORIZED",
          "PAYMENT.CANCELLED",
          "PAYMENT.IN_ANALYSIS"
        ],
        target: 'http://truppie.com/webhook',
        media: "WEBHOOK"
      }
      
      response = RestClient.post "https://sandbox.moip.com.br/v2/preferences/notifications", post_params.to_json, :content_type => :json, :accept => :json, :authorization => Rails.application.secrets[:moip_auth] 
      json_data = JSON.parse(response)
      
      
      assert_equal json_data["events"].length, 4
      assert_equal json_data["target"], 'http://truppie.com/webhook'
      assert_not_nil json_data["token"]
   end
   
   test "Consulting a notification created before" do
      skip('for a while')
      headers = {
        :content_type => 'application/json',
        :authorization => Rails.application.secrets[:moip_auth]
      }
      
      post_params = {
        events: [
          "ORDER.*",
          "PAYMENT.AUTHORIZED",
          "PAYMENT.CANCELLED"
        ],
        target: "http://truppie.com/webhook",
        media: "WEBHOOK"
      }
      
      response = RestClient.post "https://sandbox.moip.com.br/v2/preferences/notifications", post_params.to_json, :content_type => :json, :accept => :json, :authorization => Rails.application.secrets[:moip_auth] 
      json_data = JSON.parse(response)
      hook_id = json_data["id"]
      
      headers = {
        :content_type => 'application/json',
        :authorization => Rails.application.secrets[:moip_auth]
      }
      
      response = RestClient.get "https://sandbox.moip.com.br/v2/preferences/notifications/#{hook_id}", headers
      json_get_data = JSON.parse(response)
      assert_equal hook_id, json_get_data["id"]
      
   end
   
   test "resending webhook" do
     skip('just testing')
      headers = {
        :content_type => 'application/json',
        :authorization => Rails.application.secrets[:moip_auth]
      }
      
      post_params = {
        resourceId: 'EVE-DRPG123L7C06'
      }
      
      response = RestClient.get "https://sandbox.moip.com.br/v2/preferences/notifications/#{post_params[:resourceId]}", headers
      
      #response = RestClient.post "https://sandbox.moip.com.br/v2/webhooks/", post_params.to_json, :content_type => :json, :accept => :json, :authorization => Rails.application.secrets[:moip_auth] 
      json_data = JSON.parse(response)
      
      puts json_data.inspect
      assert_equal true, true
      
   end
   
   test "list existent webhooks and delete it" do
     skip("delete webhooks")
     headers = {
        :content_type => 'application/json',
        :authorization => Rails.application.secrets[:moip_auth]
      }
      
      response = RestClient.get "https://sandbox.moip.com.br/v2/preferences/notifications", headers
      
      json_data = JSON.parse(response)
      
      json_data.each do |n|
        RestClient.delete "https://sandbox.moip.com.br/v2/preferences/notifications/#{n['id']}", headers
      end
      assert_equal true, true
   end
   test "list existent webhooks after deleted" do
     skip("list webhooks")
     headers = {
        :content_type => 'application/json',
        :authorization => Rails.application.secrets[:moip_auth]
      }
      
      response = RestClient.get "https://sandbox.moip.com.br/v2/preferences/notifications", headers
      
      json_data = JSON.parse(response)
      
      puts json_data.inspect
        
      assert_equal true, true
   end
   test "make a post to webhook" do
     skip("make a post to the webhook")
     headers = {
        :content_type => 'application/json',
        :authorization => Rails.application.secrets[:moip_auth]
      }
      
      receive_url = "http://localhost:3000/webhook"
      
      post_params = {
        events: [
          "ORDER.*",
          "PAYMENT.AUTHORIZED",
          "PAYMENT.CANCELLED",
          "PAYMENT.IN_ANALYSIS"
        ],
        target: 'http://truppie.com/webhook',
        media: "WEBHOOK"
      }
      
      response = RestClient.post "http://www.truppie.com/webhook/", {}, :content_type => :json, :accept => :json
      json_data = JSON.parse(response)
      puts json_data.inspect
      assert_equal true, true
   end
  
   
   
end
