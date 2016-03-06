class Included < ActiveRecord::Base
  belongs_to :services
  belongs_to :tours
end
