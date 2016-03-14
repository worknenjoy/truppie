class Review < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :tour, dependent: :destroy
end
