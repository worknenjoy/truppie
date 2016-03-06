class CreateJoinTableOrganizersWhere < ActiveRecord::Migration
  def change
    create_join_table :organizers, :wheres do |t|
       t.index [:organizer_id, :where_id]
       t.index [:where_id, :organizer_id]
    end
  end
end
