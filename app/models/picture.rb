class Picture < ActiveRecord::Base
  
  belongs_to :tours
  
  belongs_to :category
  belongs_to :tags
  belongs_to :where
end
