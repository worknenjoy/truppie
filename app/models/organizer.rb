class Organizer < ActiveRecord::Base
  has_many :tours  
  has_and_belongs_to_many :members
  
  belongs_to :user
  belongs_to :where
end
