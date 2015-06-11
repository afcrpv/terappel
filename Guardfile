group :frontend do
  guard :bundler do
    require 'guard/bundler'
    require 'guard/bundler/verify'
    helper = Guard::Bundler::Verify.new

    files = ['Gemfile']
    files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

    # Assume files are symlinked from somewhere
    files.each { |file| watch(helper.real_path(file)) }
  end

  guard 'livereload' do
    watch(%r{app/views/.+\.(erb|haml|slim)$})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{public/.+\.(css|js|html)})
    # Rails Assets Pipeline
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) do |m|
      "/assets/#{m[3]}"
    end
  end

  guard 'rails' do
    watch('Gemfile.lock')
    watch(%r{^(config|lib)/.*})
  end
end

group :backend, halt_on_fail: true do
  guard :rspec, cmd: 'bundle exec rspec',
    all_on_start: false, all_after_pass: false,
    failed_mode: :keep do
      watch(%r{^spec/.+_spec\.rb$})
      watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }

      # Rails example
      watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
      watch(%r{^app/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
      watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
	["spec/routing/#{m[1]}_routing_spec.rb",
  "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
  "spec/acceptance/#{m[1]}_spec.rb"]
      end
      watch(%r{^spec/support/(.+)\.rb$})                  { 'spec' }
      watch('config/routes.rb')                           { 'spec/routing' }
      watch('app/controllers/application_controller.rb')  { 'spec/controllers' }

      # Capybara features specs
      watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) do |m|
	"spec/features/#{m[1]}_spec.rb"
      end
      watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
	"spec/features/#{m[1]}_spec.rb"
      end
    end

    guard :rubocop, all_on_start: false, cli: %w(--format clang --rails) do
      watch(%r{.+\.rb$})
      watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
    end

    guard 'brakeman', run_on_start: true,
      cli: 'brakeman -qA4 --no-assume-routes' do
      watch(%r{^app/.+\.(erb|haml|rhtml|rb)$})
      watch(%r{^config/.+\.rb$})
      watch(%r{^lib/.+\.rb$})
      watch('Gemfile')
    end
end
