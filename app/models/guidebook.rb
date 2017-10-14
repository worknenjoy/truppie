class Guidebook < ActiveRecord::Base
  belongs_to :organizer
  belongs_to :user
  belongs_to :form
  belongs_to :category
  has_one :destination
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :reviews
  has_and_belongs_to_many :wheres
  has_and_belongs_to_many :packages
  has_and_belongs_to_many :wheres
  has_and_belongs_to_many :comments
  has_and_belongs_to_many :tags


  accepts_nested_attributes_for :wheres
  accepts_nested_attributes_for :category
  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :organizer
  accepts_nested_attributes_for :packages, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :value, :if => Proc.new { |a| !a.packages.any? }

  validates_presence_of :title, :organizer, :user

  # This method associates the attribute ":picture" with a file attachment
  has_attached_file :picture, styles: {
      thumbnail: '300x300>',
      square: '400x400#',
      cover: '600x800>',
      medium: '500x500>',
      large: '800x800>',
  }

  has_attached_file :file

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/


  def to_param
    "#{id} #{title}".parameterize
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

end
