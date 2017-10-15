class AddFormToGuideBook < ActiveRecord::Migration
  def change
    add_reference :guidebooks, :form, index: true, foreign_key: true
  end
end
