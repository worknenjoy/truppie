class Picture < ActiveRecord::Base
  belongs_to :category
  belongs_to :tags
  belongs_to :where
end
