class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :guidebook
  belongs_to :parent
end
