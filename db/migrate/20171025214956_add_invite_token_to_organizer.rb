class AddInviteTokenToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :invite_token, :string
  end
end
