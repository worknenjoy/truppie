class Confirmed < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  has_and_belongs_to_many :tours, dependent: :destroy
end
