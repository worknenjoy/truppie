class CreateJoinTableOrganizersMembers < ActiveRecord::Migration
  def change
    create_join_table :organizers, :members do |t|
       t.index [:organizer_id, :member_id]
       t.index [:member_id, :organizer_id]
    end
  end
end
