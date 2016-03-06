class CreateConfirmeds < ActiveRecord::Migration
  def change
    create_table :confirmeds do |t|
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
