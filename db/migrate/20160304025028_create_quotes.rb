class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :content
      t.string :url
      t.string :author
      t.string :sitename

      t.timestamps null: false
    end
  end
end
