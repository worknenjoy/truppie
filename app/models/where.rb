class Where < ActiveRecord::Base
  has_and_belongs_to_many :tours
  has_and_belongs_to_many :guidebooks

  has_and_belongs_to_many :organizers
  
  has_many :attractions
  has_and_belongs_to_many :backgrounds

  accepts_nested_attributes_for :backgrounds, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :name, allow_blank: false

  before_save :set_time_zone


  def picture
    if self.try(:place_id) and !self.place_id.blank?
      @client = GooglePlaces::Client.new('AIzaSyBd61mfgh_26mtP1GFqaakPAHaaNI84j-A')
      @placeid = self.place_id
      @place = @client.spot(@placeid)
      picture_ref = @place.photos[0].photo_reference
      return "https://maps.googleapis.com/maps/api/place/photo?sensor=false&maxwidth=3000&maxheight=3000&key=AIzaSyBd61mfgh_26mtP1GFqaakPAHaaNI84j-A&photoreference=#{picture_ref}"
    end
    if self.backgrounds.any?
      return b.first.picture.url(:medium)
    end
    return 'http://lorempixel.com/400/200/'
  end


  def to_param
    "#{id} #{name}".parameterize
  end

  def defined_time_zone
    self.time_zone || Time.current.zone
  end

  private

  def set_time_zone
    if self.lat && self.long
      self.time_zone = GoogleTimezone.fetch(self.lat, self.long).time_zone_id
    end
  end
end
