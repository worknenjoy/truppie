class AddFieldsToServices < ActiveRecord::Migration
  def change
    add_column :services, :value, :integer
    add_column :services, :description, :text
    add_column :services, :included, :text, array: true, default: []    
  end
end