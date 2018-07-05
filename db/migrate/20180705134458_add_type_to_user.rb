class AddTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :type_of_user, :string
  end
end
