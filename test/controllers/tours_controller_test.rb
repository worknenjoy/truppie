include Devise::TestHelpers
require 'test_helper'
require 'json'

class ToursControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true
  
  setup do
    StripeMock.start
    @stripe_helper = StripeMock.create_test_helper
    sign_in users(:alexandre)
    @tour = tours(:morro)
    @tour_marins = tours(:picomarins)
    @mkt = tours(:tour_mkt)
    
    @payment_data = {
      id: @tour,
      method: "CREDIT_CARD",
      fullname: "Alexandre Magno Teles Zimerer",
      birthdate: "10/10/1988",
      value: @tour.value,
      token: StripeMock.generate_card_token(last4: "9191", exp_year: 1984) 
    }
    
    @basic_tour = {
      title: "A basic truppie",
      organizer: Organizer.first.name,
      where: Where.last.name
    }

    @basic_tour_with_collaborators = {
        title: "A basic truppie",
        organizer: Organizer.first.name,
        where: Where.last.name,
        collaborators: [collaborators(:one)]
    }
    
    @basic_empty_tour_with_empty = {
      title: "Another basic truppie",
      organizer: Organizer.first.name,
      where: Where.last.name,
      description: "",
      rating: "",
      value: "",
      currency: "",
      start: "",
      end: "",
      photo: "",
      availability: "",
      minimum: "",
      maximum: "",
      difficulty: "",
      address: "",
      included: "",
      nonincluded: "",
      take: "",
      goodtoknow: "",
      category_id: Category.last.id,
      tags: "",
      attractions: "",
      privacy: "",
      meetingpoint: "",
      languages: "",
      verified: "",
      status: ""
    }

  end
  
  teardown do
    StripeMock.stop
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not create tour with empty data" do
     #skip("creating tour with empty data")
     post :create, tour: {}
     assert_equal 'o campo title não pode ficar em branco', flash[:notice]
     #assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should not create tour with organizer without a title" do
     #skip("creating tour with empty data")
     post :create, tour: {organizer: Organizer.first.name}
     assert_equal 'o campo title não pode ficar em branco', flash[:notice]
     #assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should not create tour with no organizer but with a title" do
     #skip("creating tour with empty data")
     post :create, tour: {title: 'foo truppie title'}
     assert_equal 'o campo organizer não pode ficar em branco', flash[:notice]
     #assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should create tour with success flash" do
     #skip("creating tour with organizer")
     #puts @basic_tour.inspect
     post :create, tour: @basic_tour
     assert_equal 'Truppie criada com sucesso', flash[:notice]
   end
  
  test "should create tour with basic data" do
     #skip("creating tour with organizer")
     assert_difference('Tour.count') do
       post :create, tour: @basic_tour
     end
     assert_redirected_to tour_path(assigns(:tour))
   end
   
  test "should create tour with basic data with form empty sets" do
     #skip("creating tour with organizer")
     assert_difference('Tour.count') do
       post :create, tour: @basic_empty_tour_with_empty
     end
     assert_redirected_to tour_path(assigns(:tour))
   end
   
   test "should associate tags" do
     #skip("creating tour with tags")
     @basic_empty_tour_with_empty["tags"] = "#{Tag.last.name};anothertag"
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.tags[0].name, "family"
     assert_equal Tour.last.tags[1].name, "anothertag"
     assert_equal Tag.last.name, "anothertag"
   end
   
   test "should associate languages" do
     #skip("creating tour with tags")
     @basic_empty_tour_with_empty["languages"] = "#{languages(:english).name};#{languages(:portuguese).name}"
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.languages[0].name, "english"
     assert_equal Tour.last.languages[1].name, "portuguese"
   end
   
   test "should create includeds" do
     #skip("creating tour with tags")
     @basic_empty_tour_with_empty["included"] = "almoco;jantar;cafe"
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.included[0], "almoco"
     assert_equal Tour.last.included[1], "jantar"
     assert_equal Tour.last.included[2], "cafe"
   end
   
   test "should create nonincludeds" do
     #skip("creating tour with tags")
     @basic_empty_tour_with_empty["nonincluded"] = "almoco;jantar;cafe"
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.nonincluded[0], "almoco"
     assert_equal Tour.last.nonincluded[1], "jantar"
     assert_equal Tour.last.nonincluded[2], "cafe"
   end
   
   test "should create itens to take" do
     #skip("creating tour with tags")
     @basic_empty_tour_with_empty["take"] = "almoco;jantar;cafe"
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.take[0], "almoco"
     assert_equal Tour.last.take[1], "jantar"
     assert_equal Tour.last.take[2], "cafe"
   end
   
   test "should create itens good to know" do
     #skip("creating tour with tags")
     @basic_empty_tour_with_empty["goodtoknow"] = "almoco;jantar;cafe"
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.goodtoknow[0], "almoco"
     assert_equal Tour.last.goodtoknow[1], "jantar"
     assert_equal Tour.last.goodtoknow[2], "cafe"
   end
   
   test "should create with category" do
     #skip("creating tour with tags")
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.category.name, "Trekking"
   end
   
   test "should create with new category" do
     #skip("creating tour with cat")
     @basic_empty_tour_with_empty["category_id"] = "Nova"
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.category.name, "Nova"
   end
   
   test "should create with packages" do
     @basic_empty_tour_with_empty["packages_attributes"] = {"0"=>{"name"=>"Barato", "value"=>"10", "included"=>"barato;caro"}}
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.packages.first.name, "Barato"
     assert_equal Tour.last.packages.first.included, ["barato", "caro"]
   end
   
   test "should create truppie with a given start" do
     #skip("creating tour with tags")
     @basic_empty_tour_with_empty["start"] = "2016-02-02T11:00"
     post :create, tour: @basic_empty_tour_with_empty
     
     assert_equal Tour.last.start, "Tue, 02 Feb 2016 11:00:00 UTC +00:00"
   end
   
   test "should create withe the current status non published for default" do
     post :create, tour: @basic_empty_tour_with_empty
     assert_equal Tour.last.status, ""
   end

  test "should create with collaborators" do
    skip('testing collaborators add')
    post :create, tour: @basic_tour_with_collaborators
    assert_equal Tour.last.collaborators, ""
  end

  test "should show tour" do
    get :show, id: @tour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tour
    assert_response :success
  end

  test "should update tour" do
    skip("update tour")
    patch :update, id: @tour, tour: {  }
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "increment one more member" do
    skip("mock api call")
    @tour_confirmed_before = @tour.confirmeds.count
    post :confirm_presence, @payment_data
    @tour_confirmed_after = @tour.confirmeds.count
    assert_equal @tour_confirmed_before + 1, @tour_confirmed_after
  end
  
  test "should go to confirm presence with confirming price default" do
    get :confirm, {id: @tour}
    assert(assigns(:final_price))
    assert_equal(assigns(:final_price), 40)
    
  end
  
  test "should go to confirm presence with confirming package" do
    get :confirm, {id: @tour_marins, packagename: @tour_marins.packages.first.name}
    assert(assigns(:final_price))
    assert_equal(assigns(:final_price), 320)
  end
  
  #
  #  Confirm presence
  #
  #
  
  test "should decline payment if has a card error" do
    StripeMock.prepare_card_error(:card_declined)
    
    post :confirm_presence, @payment_data
    assert_equal assigns(:confirm_headline_message), "Não foi possível confirmar sua reserva"
    assert_equal assigns(:confirm_status_message), "Tivemos um problema ao processar seu cartão"
    assert_equal assigns(:status), "danger"
    assert_equal Tour.find(@tour.id).orders.any?, false
    #assert_equal Tour.find(@tour.id), token
    assert_template "confirm_presence"
  end

  test "should decline payment if has other error" do

    custom_error = Stripe::StripeError.new('new_charge', "Please knock first.", 401)

    StripeMock.prepare_error(custom_error, :new_charge)
    
    post :confirm_presence, @payment_data
    assert_equal assigns(:confirm_headline_message), "Não foi possível confirmar sua reserva"
    assert_equal assigns(:confirm_status_message), "Tivemos um problema para confirmar sua reserva, entraremos em contato para maiores informações"
    assert_equal assigns(:status), "danger"
    assert_equal Tour.find(@tour.id).orders.any?, false
    #assert_equal Tour.find(@tour.id), token
    assert_template "confirm_presence"
  end
    
  test "should confirm presence" do
    post :confirm_presence, @payment_data
    assert_equal assigns(:confirm_headline_message), "Sua presença foi confirmada para a truppie"
    assert_equal assigns(:confirm_status_message), "Você receberá um e-mail sobre o processamento do seu pagamento"
    assert_equal assigns(:status), "success"

    assert_equal Tour.find(@tour.id).orders.any?, true
    assert_equal Tour.find(@tour.id).orders.last.source_id, 'test_cc_2'
    assert_equal Tour.find(@tour.id).orders.last.payment, 'test_ch_3'
    assert_template "confirm_presence"
  end

  test "should confirm presence of a marketplace account" do
    mkt = marketplaces(:real)
    organizer = Tour.find(@tour.id).organizer
    Tour.find(@tour.id).organizer.update_attributes({:marketplace => mkt, percent: 1})
    Tour.find(@tour.id).organizer.marketplace.update_attributes({:organizer => organizer})
    Marketplace.find(mkt.id).activate

    post :confirm_presence, @payment_data
    assert_equal assigns(:new_charge)[:amount], 4000
    assert_equal assigns(:confirm_headline_message), "Sua presença foi confirmada para a truppie"
    assert_equal assigns(:confirm_status_message), "Você receberá um e-mail sobre o processamento do seu pagamento"
    assert_equal assigns(:status), "success"
    assert_equal assigns(:payment).destination.amount, 3760 

    assert_equal Tour.find(@tour.id).orders.any?, true
    assert_equal Tour.find(@tour.id).orders.first.liquid, 3760
    assert_equal Tour.find(@tour.id).orders.first.fee, 240
    assert_equal Tour.find(@tour.id).orders.last.source_id, 'test_cc_2'
    assert_equal Tour.find(@tour.id).orders.last.payment, 'test_ch_4'
    #assert_equal Customer.last.token, 'blabla'
    #assert_equal Customer.last.email, 'example@foo.com'
    assert_template "confirm_presence"
  end
  
  test "should not confirm again" do
    post :confirm_presence, @payment_data
    post :confirm_presence, @payment_data
    assert_equal "Hey, você já está confirmado neste evento, não é necessário reservar novamente!!", flash[:error]
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should not confirm if soldout" do
    @tour.confirmeds.create(user: users(:laura))
    @tour.confirmeds.create(user: users(:ciclano))
    @tour.update_attributes(:reserved => 3)
    post :confirm_presence, @payment_data
    assert_equal assigns(:confirm_headline_message), "Não foi possível confirmar sua reserva"
    assert_equal assigns(:confirm_status_message), "Este evento está esgotado"
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should unconfirm" do
    @tour.confirmeds.create(user: users(:alexandre))
    @tour.update_attributes(:reserved => 2)
    assert_equal @tour.available, 1
    post :unconfirm_presence, @payment_data
    assert_equal "Você não está mais confirmardo neste evento", flash[:success]
    assert_equal Tour.find(@tour.id).available, 3
    assert_redirected_to tour_path(assigns(:tour))
  end
  
  test "should create a order with the given id and status" do
    post :confirm_presence, @payment_data
    assert_equal assigns(:confirm_headline_message), "Sua presença foi confirmada para a truppie"
    assert_equal assigns(:confirm_status_message), "Você receberá um e-mail sobre o processamento do seu pagamento"
    assert_equal assigns(:status), "success"
    assert_template "confirm_presence"
    assert_includes ["succeeded"], Order.last.status
  end

  test "should create a order with percentage of the organizer" do
    Tour.find(@tour.id).organizer.update_attributes({percent: 1})
    post :confirm_presence, @payment_data
    assert_equal assigns(:organizer_percent), 1
    assert_equal assigns(:tour_total_percent), 0.94
    assert_equal assigns(:fees), {:fee=>240, :liquid=>3760, :total=>4000}
    assert_template "confirm_presence"
    assert_includes ["succeeded"], Order.last.status
  end

  test "should create a order with percentage of the organizer and collaborator" do
    Tour.find(@tour.id).organizer.update_attributes({percent: 1})
    @tour.collaborators.create({
        marketplace: Marketplace.last,
        percent: 20
    })
    post :confirm_presence, @payment_data
    assert_equal assigns(:organizer_percent), 1
    assert_equal assigns(:tour_total_percent), 0.94
    assert_equal assigns(:tour_collaborator_percent), 0.2

    assert_equal Order.last.fee, 1040
    assert_equal Order.last.liquid, 2960
    assert_equal Order.last.final_price, 4000

    assert_equal assigns(:fees), {:fee=>1040, :liquid=>2960, :total=>4000}
    assert_equal Tour.find(@tour.id).collaborators.first.percent, 20
    assert_template "confirm_presence"
    assert_includes ["succeeded"], Order.last.status
  end

  test "should create a order with percentage of the organizer and collaborator using dot notation in percent" do
    Tour.find(@tour.id).organizer.update_attributes({percent: 1})
    @tour.collaborators.create({
         marketplace: Marketplace.last,
         percent: 40.3
     })
    post :confirm_presence, @payment_data
    assert_equal assigns(:organizer_percent), 1
    assert_equal assigns(:tour_total_percent), 0.94

    assert_equal assigns(:tour_collaborator_percent), 0.403
    assert_equal assigns(:fees), {:fee=>1852, :liquid=>2148, :total=>4000}

    assert_equal Tour.find(@tour.id).collaborators.first.percent, 40.3
    assert_equal Order.last.fee, 1852
    assert_equal Order.last.liquid, 2148
    assert_equal Order.last.final_price, 4000

    assert_template "confirm_presence"
    assert_includes ["succeeded"], Order.last.status
  end
  
  test "should create a order on stripe with destination account fees" do
    skip("migrate to stripe")
    @payment_data["id"] = @mkt
    post :confirm_presence, @payment_data
    assert_equal assigns(:confirm_headline_message), "Sua presença foi confirmada para a truppie"
    assert_equal assigns(:confirm_status_message), "Você receberá um e-mail sobre o processamento do seu pagamento"
    assert_equal assigns(:status), "success"
    assert_equal assigns(:new_order), {:own_id=>"truppie_708514591_68086721", :items=>[{:product=>"tour with marketplace", :quantity=>1, :detail=>"subindo do pico marins na mantiqueira", :price=>4000}], :customer=>{:own_id=>"68086721_alexandre-magno", :fullname=>"Alexandre Magno", :email=>"alexanmtz@gmail.com"}, :receivers=>[{:moipAccount=>{:id=>"MPA-014A72F4426C"}, :type=>"SECONDARY", :amount=>{:percentual=>99}}]}
    assert_template "confirm_presence"
    assert_includes ["IN_ANALYSIS", "AUTHORIZED"], Order.last.status
  end
end
