source 'http://rubygems.org'
ruby '2.1.4'
gem 'rails', '4.1.7'

group :production do
  gem 'foreman',        '~> 0.75.0'
  gem 'newrelic_rpm',   '~> 3.9.6'
  gem 'rails_12factor', '~> 0.0.3'
  gem 'unicorn'
end

group :development do
  gem 'better_errors',         '~> 1.1.0'
  gem 'binding_of_caller'
  gem 'bullet',                '~> 4.14.0'
  gem 'consistency_fail'
  gem 'growl'
  gem 'guard-rspec',           '~> 4.3.1'
  gem 'pry-rails',             '~> 0.3.2'
  gem 'quiet_assets',          '~> 1.0.3'
  gem 'rb-fsevent',            '~> 0.9.4', require: false
  gem 'ruby_gntp'
  gem 'spring',                '~> 1.1.3'
  gem 'spring-commands-rspec', '~> 1.0.2'
end

group :test do
  gem 'capybara',           '~> 2.4.4'
  gem 'database_cleaner',   github: 'bmabey/database_cleaner'
  gem 'factory_girl_rails'
  gem 'simplecov',          require: false
end

group :test, :development do
  gem 'poltergeist', github: 'jonleighton/poltergeist'
  gem 'rspec-rails'
end

gem 'ancestry',             github: 'stefankroes/ancestry'
gem 'bootstrap-sass',       '~> 3.1.0'
gem 'cancancan',            '~> 1.9.2'
gem 'cocoon',               github: 'nathanvda/cocoon'
gem 'coffee-rails',         '~> 4.0.0'
gem 'compass-rails',        github: 'Compass/compass-rails'
gem 'devise',               github: 'plataformatec/devise'
gem 'draper',               '~> 1.3'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-ui-sass-rails'
gem 'jstree-rails',         github: 'tristanm/jstree-rails'
gem 'pg'
gem 'prawn',                github: 'prawnpdf/prawn'
gem 'ransack',              '~> 1.5.1'
gem 'responders'
gem 'rolify',               github: 'EppO/rolify'
gem 'sass-rails',           '~> 4.0.3'
gem 'select2-rails',        github: 'argerim/select2-rails'
gem 'simple_form',          '~> 3.1.0.rc1'
gem 'uglifier',             '>= 1.3.0'
