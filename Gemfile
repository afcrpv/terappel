source 'http://rubygems.org'
ruby "2.0.0"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.rc2'

gem 'pg'

gem 'sass-rails', "  ~> 4.0.0.rc1"
gem 'jquery-ui-sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', "~> 4.0.0"

gem 'bootstrap-sass', github: "thomas-mcdonald/bootstrap-sass"
gem "compass-rails", github: "milgner/compass-rails", branch: "rails4"

gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 1.0.1'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem "jquery-ui-rails"
gem 'select2-rails', github: "argerim/select2-rails"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use debugger
# gem 'debugger'

# Heroku gems
gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
gem 'newrelic_rpm'
gem 'unicorn'
gem 'foreman'

gem "devise", github: "plataformatec/devise"
gem 'simple_form', github: "plataformatec/simple_form"
gem "ancestry", github: "stefankroes/ancestry"
gem "cancan", github: "ncri/cancan", branch: "2.0"
gem "rolify", github: "EppO/rolify"
gem "cocoon", github: "nathanvda/cocoon"

gem 'jstree-rails', github: "tristanm/jstree-rails"
#gem 'client_side_validations', github: 'bcardarella/client_side_validations'
#gem 'client_side_validations-simple_form'
gem 'csv_builder'
gem 'haml-rails'
gem 'responders'
gem 'prawn', github: "prawnpdf/prawn"

group :test, :development do
  gem "rspec-rails"
  gem "jasmine-rails", github: "irfn/jasmine-rails"
  gem 'guard-jasmine'
  gem "poltergeist", github: "jonleighton/poltergeist"
end

group :development do
  gem 'pry-rails'
  gem "quiet_assets", ">= 1.0.1"
  gem 'rb-fsevent', :require => false
  gem 'terminal-notifier-guard'
  gem 'bullet'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem "selenium-webdriver"
  gem "database_cleaner", github: "bmabey/database_cleaner", tag: "v1.0.0.RC1"
  gem "guard-rspec", "~> 2.1.0"
  gem "simplecov", :require => false
  gem "zeus"
  gem 'cucumber-rails', require: false
  gem 'launchy'    # So you can do Then show me the page
  gem 'simplecov', :require => false
end
