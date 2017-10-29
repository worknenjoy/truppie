class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
    	t.references :user
    	t.references :organizer

      t.timestamps null: false
    end
  end
end
