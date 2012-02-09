source 'http://rubygems.org'

gem 'rails', '3.2.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>=1.0.3'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test, :development do
  gem "rspec-rails", "~> 2.6"
end

group :development do
  gem 'heroku'
  gem 'pry'
  gem 'haml-rails'
  gem 'guard'
  gem 'rb-fsevent', :git => 'https://github.com/ttilley/rb-fsevent.git',
    :branch => 'pre-compiled-gem-one-off'
  gem 'growl'
  gem 'hpricot'
  gem 'ruby_parser'
  gem "guard-bundler", ">= 0.1.3"
  gem "guard-rails", ">= 0.0.3"
  gem "guard-livereload", ">= 0.3.0"
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'
end

group :test do
  gem 'factory_girl_rails'
  gem 'spork', '~> 0.9.0.rc'
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'pickle'
  gem 'launchy'    # So you can do Then show me the page
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'mocha'
  gem "selenium-webdriver", "~> 2.13.0"
end

gem 'pg'
gem "devise"
gem 'haml'
gem 'cancan'
gem 'friendly_id', "~> 4.0.0.beta8"
gem 'formtastic'
gem 'rails3-jquery-autocomplete'
gem 'draper'
gem "ransack"
gem "thin"
gem "cocoon"

gem 'newrelic_rpm'
gem 'ancestry'
gem 'jstree-rails', :git => 'git://github.com/adamico/jstree-rails.git'
gem 'simple_form', :git => 'git://github.com/plataformatec/simple_form.git'
gem 'rails_admin', git: "https://github.com/sferik/rails_admin.git"
