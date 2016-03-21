class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "Não é um e-mail válido") unless
      value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end

class Subscriber < ActiveRecord::Base
  
  include ActiveModel::Validations
  
  validates :email, presence: true, email: true, uniqueness: true
  
end
