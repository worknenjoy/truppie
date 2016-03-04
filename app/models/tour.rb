class Tour < ActiveRecord::Base
  belongs_to :organizer
  belongs_to :pictures
  belongs_to :where
  belongs_to :user
  belongs_to :included
  belongs_to :category
  belongs_to :tags
  belongs_to :attractions
  belongs_to :confirmed
  belongs_to :languages
  belongs_to :reviews
end
