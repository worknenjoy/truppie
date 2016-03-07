include ActionView::Helpers::DateHelper

class Tour < ActiveRecord::Base
  belongs_to :organizer
  belongs_to :where
  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :attractions
  has_and_belongs_to_many :confirmeds
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :reviews
  
  
  def duration
    distance_of_time_in_words(self.end - self.start)
  end
  
  def level
    case self.difficulty
    when 1
      "very easy"
    when 2
      "easy"
    when 3
      "moderate"
    when 4
      "hard"
    when 5
      "very hard"
    else
      "not defined"
    end
  end
  
end
