class AddDescriptionToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :description, :text
  end
end
