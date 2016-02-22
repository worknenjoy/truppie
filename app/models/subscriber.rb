class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "is not an email") unless
      value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end

class Subscriber < ActiveRecord::Base
  
  include ActiveModel::Validations
  attr_accessor :email
  
  
  validates :email, presence: true, email: true
  validates :email, uniqueness: true
  
end
