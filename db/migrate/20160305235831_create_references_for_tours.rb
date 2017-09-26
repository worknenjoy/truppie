class CreateReferencesForTours < ActiveRecord::Migration
  def change
    add_foreign_key :tours, :organizers
    add_foreign_key :tours, :users
    add_foreign_key :tours, :tags
    add_foreign_key :tours, :categories
    add_foreign_key :tours, :attractions
    add_foreign_key :tours, :confirmeds
    add_foreign_key :tours, :languages
    
    add_foreign_key :organizers, :members
    add_foreign_key :organizers, :users
    add_foreign_key :organizers, :wheres
    
    add_foreign_key :attractions, :languages
    add_foreign_key :attractions, :quotes
    
    add_foreign_key :reviews, :users
    add_foreign_key :reviews, :tours
    
    add_foreign_key :confirmeds, :users
    
    add_foreign_key :members, :users
  end
end
