class Tour < ActiveRecord::Base
  belongs_to :organizer
  
  has_many :pictures
  belongs_to :wheres
  belongs_to :users
  has_many :includeds
  has_many :nonincludeds
  has_one :category
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :attractions
  
  has_many :confirmed
  has_many :languages
  has_many :reviews
end
