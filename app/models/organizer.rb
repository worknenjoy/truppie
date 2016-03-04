class Organizer < ActiveRecord::Base
  belongs_to :members
  belongs_to :user
  belongs_to :where
  belongs_to :tags
end
