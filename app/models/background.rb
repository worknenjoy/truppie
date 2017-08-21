class Background < ActiveRecord::Base

  has_attached_file :picture, styles: {
      thumbnail: '300x300>',
      square: '400x400#',
      cover: '600x800>',
      medium: '800x800>',
      large: '1200x1200>',
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

end
