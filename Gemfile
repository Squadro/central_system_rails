source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use debugger
# gem 'debugger', group: [:development, :test]

# ----------------------------------------------- #
# 			END OF DEFAULT RAILS GEMS			  #
# ----------------------------------------------- #

gem 'mongoid', '~> 4.0.0.alpha1'
gem 'devise', '~> 3.2.2'

gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails'
gem 'chosen-rails'
gem 'cloudinary'

group :development, :test do
  gem "rspec-rails", "~> 2.14.0"
  gem 'fabrication', '~> 2.9.3'
  gem 'faker', '~> 1.2.0'
  gem 'mongoid-rspec', '~> 1.10.0'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'simplecov', '~> 0.8.2'
end

group :development do
  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-bundler', '~> 1.1.1'
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

gem 'puma', '~> 2.7.1'
