include ActionView::Helpers::DateHelper

class Tour < ActiveRecord::Base
  
  belongs_to :organizer
  has_and_belongs_to_many :wheres
  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :attractions
  has_and_belongs_to_many :confirmeds, dependent: :destroy
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :reviews, dependent: :destroy
  has_and_belongs_to_many :packages, dependent: :destroy
  has_and_belongs_to_many :collaborators, dependent: :destroy
  
  has_and_belongs_to_many :orders
  
  accepts_nested_attributes_for :packages, allow_destroy: true, reject_if: :all_blank

  accepts_nested_attributes_for :collaborators, allow_destroy: true, reject_if: :all_blank

  accepts_nested_attributes_for :organizer

  accepts_nested_attributes_for :languages

  accepts_nested_attributes_for :category

  accepts_nested_attributes_for :wheres, allow_destroy: true
  
  validates_presence_of :title, :organizer, :wheres, :start, :end

  default_scope { where("removed IS NOT true") }

  validates_each :start, :end do |model, attr, value|
    model.errors.add(attr, I18n.t('errors.messages.invalid')) if value.nil?
  end

  #validates_each :value do |model, attr, value|
  #  model.errors.add(attr, 'deve ser um preço válido') if value.nil?
  #end

  validates_presence_of :value, :if => Proc.new { |a| !a.packages.any? }
  
  scope :nexts, lambda { where("start >= ?", Time.now).order("start ASC") }

  scope :past, lambda { where("start <= ?", Time.now).order("start DESC") }
  
  scope :recents, lambda { where(status: 'P').order(:start).reverse }

  scope :recents_all, lambda { order(:start).reverse }
  
  scope :publisheds, -> { where(status: 'P') }
  
  # This method associates the attribute ":picture" with a file attachment
  has_attached_file :picture, styles: {
    thumbnail: '300x300>',
    square: '400x400#',
    cover: '600x800>',
    medium: '500x500>',
    large: '800x800>',
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  
  def packages_attributes=(attributes)
    # Process the attributes hash
    #puts '------- attributes hash ----------'
    #puts attributes.inspect
  end


  
  def how_long
    distance_words = distance_of_time_in_words(self.end - self.start)
    time_diff_components = Time.diff(self.end, self.start)
    if time_diff_components[:day] >= 1
      "de <strong>#{I18n.l(self.start, format: '%d de %B')} </strong> a <strong>#{I18n.l(self.end, format: '%d de %B')}</strong>".html_safe
    else
      "Duração total de <strong>#{distance_words}</strong>".html_safe
    end
  end

  def where
    if self.wheres.present?
      self.wheres.first
    end
  end

  def starttime
    Time.now
  end

  def endtime
    Time.now
  end
  
  def days
    time_diff_components = Time.diff(self.end, self.start)
    if time_diff_components[:day].to_i == 0
      I18n.l(self.start, format: '%d')
    else
      "<small>de</small> #{I18n.l(self.start, format: '%d')} <small> a </small> #{I18n.l(self.end, format: '%d')}"
    end
  end
  
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
    if !self.try(:value)
      minor = 999999999
      if self.try(:packages) and !self.value
        self.packages.each do |p|
          if !p.nil?
            if p.try(:value)
              minor = p.value if p.value < minor
            end
          end 
        end
      end
      return "<small>A partir de R$</small> #{minor}"
    else
      case self.currency
      when 'BRL'
        "<small>R$</small> #{self.value}"
      when 'US'
        self.value
      when 'EURO'
        self.value
      else
        self.value
      end
    end
  end
  
  def total_earned_until_now
    self.orders.to_a.sum(&:amount_total)
  end
  
  def total_taxes
    self.orders.to_a.sum(&:total_fee)
  end
  
  def price_with_taxes
    self.orders.to_a.sum(&:price_with_fee)
  end
  
  def available
    if self.availability
     self.availability - self.reserved
    else
      nil
    end
  end
  
  def soldout?
    if self.available
      self.available <= 0  
    else
      false      
    end
  end
  
end
