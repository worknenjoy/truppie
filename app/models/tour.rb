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
  has_and_belongs_to_many :reviews, dependent: :destroy
  
  scope :nexts, lambda { where("start > ?", Date.today) }
  
  
  def to_param
    "#{id} #{title}".parameterize
  end
  
  def duration
    distance_of_time_in_words(self.end - self.start)
  end
  
  def days_left
     Time.diff(self.start, Time.now)[:day]
  end
  
  def level
    case self.difficulty
    when 1
      "muito fácil"
    when 2
      "fácil"
    when 3
      "moderada"
    when 4
      "difícil"
    when 5
      "muito difícil"
    else
      "não definida"
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
  
  def available
    self.availability - self.confirmeds.count
  end
  
  def soldout?
    self.available <= 0
  end
  
end
