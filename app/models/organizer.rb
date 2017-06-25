class Organizer < ActiveRecord::Base
  has_many :tours  
  has_and_belongs_to_many :members
  belongs_to :marketplace
  
  belongs_to :user
  belongs_to :where
  
  scope :publisheds, -> { where(status: 'P') }

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

  validates :name, uniqueness: true

  accepts_nested_attributes_for :tours, allow_destroy: true, reject_if: :all_blank

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  
  def balance
    if self.market_place_active
      begin
        balance = Stripe::Balance.retrieve(self.marketplace.token)
        return balance
      rescue => e
        puts e.inspect
        return false
      end
    else
      false
    end  
  end

  def clients
    clients_array = []
    self.tours.each do |t|
      t.orders.each do |o|
        clients_array.push o.user
      end
    end
    clients_array.uniq
  end


    
end
