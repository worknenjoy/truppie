class CreateJoinTableGuidebooksServices < ActiveRecord::Migration
  def change
    create_join_table :guidebooks, :services do |t|
       t.index [:guidebook_id, :service_id]
       t.index [:service_id, :guidebook_id]        
    end
  end
end
