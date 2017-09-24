class Where < ActiveRecord::Base
  has_many :tours
  has_and_belongs_to_many :organizers
  
  has_many :attractions
  has_and_belongs_to_many :backgrounds

  accepts_nested_attributes_for :backgrounds, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :name, allow_blank: false
  
end
