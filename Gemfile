source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
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
  gem 'haml-rails'
  gem 'guard'
  case RUBY_PLATFORM
  when /linux/
    gem 'rb-inotify'
    gem 'libnotify'
  when /darwin/
    gem 'rb-fsevent', :git => 'https://github.com/ttilley/rb-fsevent.git',
      :branch => 'pre-compiled-gem-one-off'
    gem 'growl'
  else
    gem 'rb-fchange'
    gem 'rb-notifu'
    gem 'win32console'
  end
end

group :test do
  gem 'factory_girl_rails'
  gem 'spork', '~> 0.9.0.rc'
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'launchy'    # So you can do Then show me the page
  gem 'pickle', :git => "https://github.com/ianwhite/pickle.git"
  gem 'database_cleaner'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'
end

gem 'sorcery'
gem 'haml'
gem 'simple_form'
