class CreateJoinTableBackgroundsWheres < ActiveRecord::Migration
  def change
    create_join_table :backgrounds, :wheres do |t|
      t.index [:background_id, :where_id]
      t.index [:where_id, :background_id]
    end
  end
end
