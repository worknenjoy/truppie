class CreateJoinTableAttractionToTour < ActiveRecord::Migration
  def change
    create_join_table :tours, :attractions do |t|
       t.index [:tour_id, :attraction_id]
       t.index [:attraction_id, :tour_id]
    end
  end
end
