class CreateJoinTableToursPackages < ActiveRecord::Migration
  def change
    create_join_table :tours, :packages do |t|
       t.index [:tour_id, :package_id]
       t.index [:package_id, :tour_id]
    end
  end
end
