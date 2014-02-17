source 'http://rubygems.org'
ruby "2.1.0"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'pg'

gem 'sass-rails', '~> 4.0.0'
gem 'jquery-ui-sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', "~> 4.0.0"

gem 'bootstrap-sass', '~> 3.1.0'
gem "compass-rails", github: "Compass/compass-rails"

gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "jquery-turbolinks"
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'select2-rails', github: "argerim/select2-rails"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use debugger
# gem 'debugger', group: [:development, :test]

# Heroku gems
gem 'rails_12factor', group: :production
gem 'newrelic_rpm'
gem 'unicorn'
gem 'unicorn-rails'
gem 'foreman'

gem "devise", github: "plataformatec/devise"
gem 'simple_form', github: "plataformatec/simple_form"
gem "ancestry", github: "stefankroes/ancestry"
gem "cancan", github: "ncri/cancan", branch: "2.0"
gem "rolify", github: "EppO/rolify"
gem "cocoon", github: "nathanvda/cocoon"

gem 'jstree-rails', github: "tristanm/jstree-rails"
gem 'haml-rails'
gem 'responders'
gem 'prawn', github: "prawnpdf/prawn"
gem 'draper', '~> 1.0'

group :test, :development do
  gem "rspec-rails"
  gem "jasmine-rails"
  gem "poltergeist", github: "jonleighton/poltergeist"
end

group :development do
  gem "spring", "~> 1.1.1"
  gem "spring-commands-rspec"
  gem "guard-rspec", "~> 2.1.0"
  gem "guard-jasmine"
  gem 'pry-rails'
  gem "quiet_assets", ">= 1.0.1"
  gem 'rb-fsevent', :require => false
  gem 'terminal-notifier-guard'
  gem 'bullet'
  gem "consistency_fail"
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem "selenium-webdriver"
  gem "database_cleaner", github: "bmabey/database_cleaner", tag: "v1.0.0.RC1"
  gem "simplecov", :require => false
  gem 'launchy'    # So you can do Then show me the page
end
