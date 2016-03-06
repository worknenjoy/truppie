class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :user, index: true, null: false
      t.references :organizer, index: true, null: false
      
      t.timestamps null: false
    end
  end
end
