class AddValChosenByUserToTours < ActiveRecord::Migration
  def change
    add_column :tours, :value_chosen_by_user, :boolean, default: false
  end
end
