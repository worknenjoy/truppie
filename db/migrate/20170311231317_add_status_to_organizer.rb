class AddStatusToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :status, :string
  end
end
