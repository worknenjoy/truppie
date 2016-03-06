class Attraction < ActiveRecord::Base
  has_and_belongs_to_many :tours
  
  has_many :wheres
  
  belongs_to :languages
  has_one :quotes
end
