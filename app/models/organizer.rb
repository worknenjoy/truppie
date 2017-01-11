class Organizer < ActiveRecord::Base
  has_many :tours  
  has_and_belongs_to_many :members
  belongs_to :marketplace
  
  belongs_to :user
  belongs_to :where
  
  
  def to_param
    "#{id} #{name}".parameterize
  end
  
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
  
  def balance
    if self.market_place_active
      response = RestClient.get "https://sandbox.moip.com.br/v2/balances", :content_type => :json, :accept => :json, :authorization => "OAuth #{self.marketplace.token}"
      json_data = JSON.parse(response)
      json_data
    else
      false
    end  
  end
    
end
