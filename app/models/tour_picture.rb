class TourPicture < ActiveRecord::Base
  belongs_to :tour
  has_attached_file :photo, styles: {
    mini: '200x250#',
    thumbnail: '300x300>',
    square: '400x400#',
    cover: '600x800>',
    medium: '500x500>',
    large: '800x800>',
  }
  
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end
