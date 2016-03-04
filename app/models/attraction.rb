class Attraction < ActiveRecord::Base
  belongs_to :category
  belongs_to :tags
  belongs_to :language
  belongs_to :quotes
end
