class AddBackgroundToWhere < ActiveRecord::Migration
  def change
    add_reference :wheres, :background, index: true, foreign_key: true
  end
end
