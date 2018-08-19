class CreateJoinTableToursServices < ActiveRecord::Migration
  def change
    create_join_table :tours, :services do |t|
       t.index [:tour_id, :service_id]
       t.index [:service_id, :tour_id]        
    end
  end
end
