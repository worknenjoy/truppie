ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  
  self.use_transactional_fixtures = true
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  # Add more helper methods to be used by all tests here...
  def randomize_timezone!
    offsets = ActiveSupport::TimeZone.all.group_by(&:formatted_offset)
    zones = offsets[offsets.keys.sample]
    Time.zone = zones.sample

    puts "Current random time zone: #{Time.zone}. Time zone name: #{Time.zone.name.inspect}"
  end
end
