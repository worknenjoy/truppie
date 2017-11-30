class AddValChosenByUserToGuidebooks < ActiveRecord::Migration
  def change
    add_column :guidebooks, :value_chosen_by_user, :boolean, default: false
  end
end
