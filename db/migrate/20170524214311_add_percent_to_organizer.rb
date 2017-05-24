class AddPercentToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :percent, :integer, :default => 3
  end
end
