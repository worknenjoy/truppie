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


  accepts_nested_attributes_for :wheres
  accepts_nested_attributes_for :category
  accepts_nested_attributes_for :languages
  accepts_nested_attributes_for :packages, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :value, :if => Proc.new { |a| !a.packages.any? }

  validates_presence_of :title, :organizer, :user

end
