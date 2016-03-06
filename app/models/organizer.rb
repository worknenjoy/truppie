class Organizer < ActiveRecord::Base
  has_many :tours  
  has_many :members
  
  belongs_to :user
  belongs_to :where
end
