source 'https://rubygems.org'

gem 'rails', '4.2.5.1'
gem 'pg', '~> 0.20'
gem 'sass-rails', '~> 5.0'
gem 'compass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'

# Servers
gem 'puma'
gem 'thin'

# Mail
gem 'maily_herald'
gem 'maily_herald-webui'

# Authentication
gem 'devise', '~> 3.2'
gem 'omniauth'
gem 'omniauth-facebook'

# Payments
gem 'moip2', '~> 0.1.4'
gem 'pagseguro-oficial', '~> 2.5.0'
gem 'stripe'

# Image upload
gem 'paperclip', :git=> 'https://github.com/thoughtbot/paperclip', :ref => '523bd46c768226893f23889079a7aa9c73b57d68'
gem 'aws-sdk', '< 2.0'
gem 'paperclip-aws'

# Utilities
gem 'redis'
gem 'bourbon'
gem 'rest-client'
gem 'json'
gem 'fakeredis'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'activesupport-json_encoder'
gem 'activerecord-session_store'
gem 'mime-types', '2.6.2'
gem 'time_diff'
gem 'timecop'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'byebug'
  gem 'i18n-tasks', '~> 0.9.18'
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :test do
  gem 'stripe-ruby-mock', :require => 'stripe_mock', :git => 'git://github.com/alexanmtz/stripe-ruby-mock.git', :branch => 'master'
  gem 'database_cleaner'
  gem 'fakeweb'
  gem 'mocha'
end
