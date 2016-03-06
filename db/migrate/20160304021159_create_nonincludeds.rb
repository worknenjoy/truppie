class CreateNonincludeds < ActiveRecord::Migration
  def change
    create_table :nonincludeds do |t|
      t.references :service, index: true, null: false

      t.timestamps null: false
    end
    
  end
end
