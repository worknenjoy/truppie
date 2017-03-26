class AddPolicyToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :policy, :string, array: true, default: []
  end
end
