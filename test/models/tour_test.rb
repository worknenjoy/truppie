require 'test_helper'

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
     assert_equal 2, Tour.last.confirmeds.size
   end
   
   test "languages" do
     assert_equal 2, Tour.last.languages.size
   end
   
   test "reviews" do
     assert_equal 2, Tour.last.reviews.size
   end
   
end
