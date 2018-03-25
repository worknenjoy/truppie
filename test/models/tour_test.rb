require 'test_helper'
require 'json'

class TourTest < ActiveSupport::TestCase

  setup do
    @tour = tours(:morro)
    @tour_alt = tours(:gavea)
    @marins = tours(:picomarins)
  end

  test "tours fixtures created" do
     assert_equal 6, Tour.count
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
     @tour.confirmeds.create(user: User.last)
     @tour.update_attributes(:reserved => 1)
     assert_equal 2, Tour.find(@tour.id).available
   end

   test "confirmed availability soldout still possible" do
     @tour.confirmeds.create(user: users(:laura))
     @tour.confirmeds.create(user: users(:alexandre))
     @tour.update_attributes(:reserved => 2)
     assert_equal false, Tour.find(@tour.id).soldout?
   end

   test "confirmed availability soldout not possible" do
     @tour.confirmeds.create(user: users(:laura))
     @tour.confirmeds.create(user: users(:alexandre))
     @tour.confirmeds.create(user: users(:fulano))
     @tour.confirmeds.create(user: users(:ciclano))
     @tour.update_attributes(:reserved => 4)
     assert_equal true, Tour.find(@tour.id).soldout?
   end

   test "languages" do
     assert_equal 2, Tour.last.languages.size
   end

   test "reviews" do
     assert_equal 2, Tour.last.reviews.size
   end

   test "friendly duration" do
      assert_equal "aproximadamente 1 hora", Tour.first.duration
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

     assert_equal day, 'Duração total de <strong>aproximadamente 1 hora</strong>'

   end

   test "day counter" do
     day = @marins.days

     assert_equal '<small>de</small> 18 <small> a </small> 19', day
   end

   test "day counter same day" do
     day = @tour.days

     assert_equal '22', day
   end

   test "orders by truppie" do
     tour_with_orders = tours(:with_orders)
     orders = tour_with_orders.orders
     assert_equal orders.size, 3
   end

   test "truppie with a order with total of taxes" do
      tour_to_order = tours(:morro)

      #puts payment.inspect
      order = tour_to_order.orders.create(
        :status => 'succeeded',
        :price => 1000,
        :status_history => ['succeeded'],
        :final_price => 1000,
        :payment => 'somepayment_id',
        :user => User.last,
        :tour => Tour.last,
        :fee => 10,
        :liquid => 990
      )
     assert_equal tour_to_order.total_taxes, 10
     assert_equal tour_to_order.price_with_taxes, 990
     assert_equal tour_to_order.total_earned_until_now, 1000
   end

   test "truppie with a order with total of taxes with nil" do
      tour_to_order = tours(:morro)

      #puts payment.inspect
      order = tour_to_order.orders.create(
        :status => 'succeeded',
        :price => 1000,
        :status_history => ['succeeded'],
        :final_price => 1000,
        :payment => 'somepayment_id',
        :user => User.last,
        :tour => Tour.last,
        :liquid => 990
      )
     assert_equal tour_to_order.total_taxes, 0
     assert_equal tour_to_order.price_with_taxes, 990
     assert_equal tour_to_order.total_earned_until_now, 1000
   end

   test "truppie with final_price nil" do
      tour_to_order = tours(:morro)

      #puts payment.inspect
      order = tour_to_order.orders.create(
        :status => 'succeeded',
        :price => 1000,
        :status_history => ['succeeded'],
        :payment => 'somepayment_id',
        :user => User.last,
        :tour => Tour.last
      )
     assert_equal tour_to_order.total_taxes, 0
     assert_equal tour_to_order.price_with_taxes, 0
     assert_equal tour_to_order.total_earned_until_now, 0
   end

   test "should set a collaborator that will take 20% on this transaction" do
     tour = tours(:morro)
     mkt = marketplaces(:one)

     c = tour.collaborators.create({
        marketplace: mkt,
        percent: 20
     })

     assert_equal tour.collaborators.first.percent, 20

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
   # Value chosen by user | "Fair Price"
   #

  test "should be valid without setting value" do
    tour_fair_price = tours(:morro_fair_price)
    assert_nil tour_fair_price.value
    assert tour_fair_price.valid?
  end
end
