class Attraction < ActiveRecord::Base
  has_and_belongs_to_many :tours
  belongs_to :languages
  has_one :quotes
end
