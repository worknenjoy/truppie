class AddPercentToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :percent, :decimal, precision: 5, scale: 2
  end
end
