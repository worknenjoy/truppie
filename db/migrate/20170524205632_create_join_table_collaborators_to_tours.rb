class CreateJoinTableCollaboratorsToTours < ActiveRecord::Migration
  def change
    create_join_table :tours, :collaborators do |t|
       t.index [:tour_id, :collaborator_id]
       t.index [:collaborator_id, :tour_id]
    end
  end
end
