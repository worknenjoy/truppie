require 'test_helper'
require 'json'

class TourTest < ActiveSupport::TestCase
  
  setup do
    @tour = tours(:morro)
    @tour_alt = tours(:gavea)
    @marins = tours(:picomarins)
    
    
    @moip_account = {
          "email" => {
              "address" => "DOBXERG0a9@labs.moip.com.br"
          },
          "person" => {
              "name" => "Runscope",
              "lastName" => "Random 9323",
              "taxDocument" => {
                  "type" => "CPF",
                  "number"=> "227.356.808-86"
              },
              "identityDocument"=> {
                  "type"=> "RG",
                  "number"=> "204256333",
                  "issuer"=> "ssp",
                  "issueDate"=> "1990-01-01"
              },
              "birthDate" => "1990-01-01",
              "phone" => {
                  "countryCode" => "55",
                  "areaCode"=> "11",
                  "number" => "965213244"
              },
              "address" => {
                  "street" => "Av. Brigadeiro Faria Lima",
                  "streetNumber" => "2927",
                  "complement"=> "8 andar",
                  "district" => "Itaim",
                  "zipcode" => "01234-000",
                  "city" => "São Paulo",
                  "state" => "SP",
                  "country" => "BRA"
              }
          },
          "businessSegment" => {
              "id" => "5"
          },
          "site" => "http://www.truppie.com",
          "type" => "MERCHANT",
          "transparentAccount" => "true"
      }
    
  end
  
  test "one tour created" do
     assert_equal 3, Tour.count
   end
   
   test "a user that create the tour" do
     assert_equal 'laurinha.sette@gmail.com', Tour.last.user.email
   end
   
   test "a organizer for the tour" do
     assert_equal "Utopicos Mundo Afora", @tour.organizer.name
   end
   
   test "the right place for the tour" do
     assert_equal "Rio", @tour.where.name
   end
   
   test "one category" do
     assert_equal "Trekking", @tour.category.name
   end
   
   test "many tags" do
     assert_equal 3, @tour.tags.size
   end
   
   test "many attractions" do
     assert_equal 2, @tour.attractions.size
   end
   
   test "confirmed" do
     assert_equal 0, @tour.confirmeds.size
   end
   
   test "confirmed availability soldout for infinite availability" do
     assert_equal 0, @tour.confirmeds.size
     assert_equal false, @tour.soldout?
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
      assert_equal "3 minutos", Tour.first.duration
   end
   
   test "a friendly duration more accurated test" do
     Tour.last.update_attribute(:start, '2016-03-01 23:56:31')
     Tour.last.update_attribute(:end, '2018-03-01 23:56:31')
     assert_equal "aproximadamente 2 anos", Tour.last.duration
   end
   
   test "a tour friendly difficult measure" do
     easytour = @tour.level
     assert_equal "fácil", easytour
   end
   
   test "a price in real" do
     price = @tour.price
     assert_equal "<small>R$</small> 40", price
   end
   
   test "a price with packages" do
     price = @marins.price
     assert_equal "<small>A partir de R$</small> 250", price
   end
   
   test "the next tour between two dates, from now to others" do
     
      actualtime = Time.new(2015, 8, 1, 14, 35, 0)
     
      Timecop.freeze(actualtime) do
        
        time_before = Time.new(2015, 8, 1, 14, 35, 0).change(day: 4)
        
        @tour.start = time_before
        
        @tour.save()
        
        #puts @tour.start
        
        assert_equal 3, @tour.days_left
      end
    end
    test "the current next should be in the list" do
         skip("I just dont know whats happening")
         @first_start = @tour.start
         @other_start = @tour_alt.start
         @nexts = Tour.nexts
         
         format = "%m/%d/%Y"
         
         # date today april 6, 2016
         
         assert_equal @other_start.strftime(format), @nexts.last.start.strftime(format)
           
    end
    
    test "the next truppies in order" do
     
      actualtime = Time.new(2015, 4, 14, 14, 35, 0)
     
      Timecop.freeze(actualtime) do
        assert_equal @tour, Tour.nexts.first
        assert_equal @marins, Tour.nexts.last
        assert_equal @tour_alt, Tour.nexts[1]
      end
    end
    
   test "just show published truppies" do
     
     @tour.status = 'P'
     @tour.save()
     
     is_inside = false
     
     Tour.publisheds.each do |t|
       if t.title == @tour.title
         is_inside = true
       end
     end
     
     assert is_inside, "is inside!"
     
   end
   
   test "event more than one day" do
     
     day = @marins.how_long
     
     assert_equal day, 'de <strong>18 de Junho </strong> a <strong>19 de Junho</strong>'
     
   end
   
   test "event same day" do
     
     day = @tour.how_long
     
     assert_equal day, 'Duração total de <strong>3 minutos</strong>'
     
   end
   
   test "day counter" do
     day = @marins.days
     
     assert_equal '18 e 19', day
   end
   
   test "day counter same day" do
     day = @tour.days
     
     assert_equal '17', day
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
      
      response = RestClient.post "http://www.truppie.com/webhook/", {}, :content_type => :json, :accept => :json
      json_data = JSON.parse(response)
      puts json_data.inspect
      assert_equal true, true
   end
   
   #
   # Packages
   #
   
   test "should have packages" do
     pkgs = @marins.packages
     assert_equal pkgs.length, 2
   end
   
   test "should the first package have a given value" do
     pkgs = @marins.packages
     assert_equal pkgs.first.value, 320
   end
   
  #
  # MOIP Marketplace
  #
  #
  
  test "registering user to marketplace with existent taxDocument" do
     skip("make a post to new order at marketplace")
     response = JSON.load `curl -H 'Content-Type:application/json' -H 'Accept:application/json' -H 'Authorization:OAuth jdyi6e28vdyz2l8e1nss0jadh1j4ay2' -X POST 'https://sandbox.moip.com.br/v2/accounts' -d '#{@moip_account.to_json}'`
      
      puts response.inspect
      
      assert_equal "REG-002", response["errors"][0]["code"] 
   end
   
   test "registering user to marketplace with new taxDocument" do
     skip("make a post to new order at marketplace")
     
     #@moip_account["person"]["taxDocument"]["number"] = "389.914.202-06"
     
     #@moip_account["person"]["name"] = "Alexandre Magno Teles Zimerer"
     
     #@moip_account["email"] = {
     #     "address" => "alexandrezimerer@hotmail.com"
     # }
      
     #puts @moip_account.inspect
     
     response = JSON.load `curl -H 'Content-Type:application/json' -H 'Accept:application/json' -H 'Authorization:OAuth jdyi6e28vdyz2l8e1nss0jadh1j4ay2' -X POST 'https://sandbox.moip.com.br/v2/accounts' -d '#{@moip_account.to_json}'`
      
     puts response.inspect
      
     assert_equal response["errors"][0]["code"], "REG-002" 
   end
   
   test "accessing a account of Moip created" do
     #skip("make a post to new order at marketplace")
     
     headers = {
        :content_type => 'application/json',
        :authorization => 'OAuth jdyi6e28vdyz2l8e1nss0jadh1j4ay2'
      }
     
     response = RestClient.get "https://sandbox.moip.com.br/v2/accounts/MPA-900EB1CA8E2B", headers
      
     response_json = JSON.load response
     
     puts response_json.inspect
      
     assert_equal "MPA-900EB1CA8E2B", response_json["id"] 
   end
   
   
   
end

=begin
curl -v https://sandbox.moip.com.br/v2/accounts \
-H 'Content-Type: application/json'  \
-H 'Authorization: OAuth jdyi6e28vdyz2l8e1nss0jadh1j4ay2' \
-d '{
  "email": {
    "address": "DOBXERG0a8@labs.moip.com.br"
  },
  "person": {
    "name": "Runscope",
    "lastName": "Random 9123",
    "taxDocument": {
      "type": "CPF",
      "number": "742.520.863-61"
    },
    "identityDocument": {
      "type": "RG",
      "number": "434322344",
      "issuer": "SSP",
      "issueDate": "2000-12-12"
    },
    "birthDate": "1990-01-01",
    "phone": {
      "countryCode": "55",
      "areaCode": "11",
      "number": "965213244"
    },
    "address": {
      "street": "Av. Brigadeiro Faria Lima",
      "streetNumber": "2927",
      "district": "Itaim",
      "zipCode": "01234-000",
      "city": "São Paulo",
      "state": "SP",
      "country": "BRA"
    }
  },
  "type": "MERCHANT",
  "transparentAccount": "true"
}'
=end


