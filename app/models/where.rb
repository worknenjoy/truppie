class Where < ActiveRecord::Base
  has_and_belongs_to_many :tours
  has_and_belongs_to_many :guidebooks

  has_and_belongs_to_many :organizers
  
  has_many :attractions
  has_and_belongs_to_many :backgrounds

  accepts_nested_attributes_for :backgrounds, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :name, allow_blank: false

  before_save :set_time_zone


  def to_param
    "#{id} #{name}".parameterize
  end

  private

  def set_time_zone
    if self.lat && self.long
      self.time_zone = GoogleTimezone.fetch(self.lat, self.long).time_zone_id
    end
  end
end
