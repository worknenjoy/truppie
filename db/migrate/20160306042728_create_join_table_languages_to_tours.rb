class CreateJoinTableLanguagesToTours < ActiveRecord::Migration
  def change
    create_join_table :languages, :tours do |t|
       t.index [:language_id, :tour_id]
       t.index [:tour_id, :language_id]
    end
  end
end
