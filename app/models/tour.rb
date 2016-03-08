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
  
  def to_param
    "#{id} #{title}".parameterize
  end
  
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
  
  def price
    case self.currency
    when 'BRL'
      "<small>R$</small> " + self.value.to_s
    when 'US'
      "<small>$</small> " + self.value.to_s
    when 'EURO'
      "<small>€</small> " + self.value.to_s
    else
      self.value
    end
  end
  
end
