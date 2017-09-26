source 'https://rubygems.org'

gem "mime-types", '2.6.2'

gem 'dotenv-rails', groups: [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'

gem 'puma'
gem 'stripe'
gem 'stripe-ruby-mock', :require => 'stripe_mock', :git => 'git://github.com/alexanmtz/stripe-ruby-mock.git', :branch => 'master'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'compass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'thin'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise', '~> 3.2'
gem 'omniauth'
gem 'omniauth-facebook'

gem 'moip2', '~> 0.1.4'
gem 'pagseguro-oficial', '~> 2.5.0'
gem 'rest-client'
gem 'json'
gem 'fakeredis'

gem 'time_diff'
gem 'timecop' 
gem 'redis'

gem 'bourbon'

gem 'paperclip', :git=> 'https://github.com/thoughtbot/paperclip', :ref => '523bd46c768226893f23889079a7aa9c73b57d68'
gem 'aws-sdk', '< 2.0'
gem 'paperclip-aws'

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'database_cleaner'
  gem 'fakeweb'
  gem 'mocha'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'i18n-tasks', '~> 0.9.18'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end