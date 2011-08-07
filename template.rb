# Template for creating an awesome rails 3 app!
# See the README for more info.

APP_NAME = app_name
RUBY_NAME = "ruby-1.9.2-p290"
RUBY_GEMSET_NAME = "#{RUBY_NAME}@#{APP_NAME}"
TEMPLATE_PATH = File.expand_path('../', __FILE__)

if yes?("\r\nInstall with postgres?")
  # INSTALL WITH POSTGRES
  POSTGRES_PASS = ask("\r\nEnter your postgres password:")
  USE_POSTGRES = true
  gem 'pg'
else
  USE_POSTGRES = false
end

# COPY TEMPLATE FILES INTO NEW PROJECT
directory "#{TEMPLATE_PATH}/template", "." , :force => true

# CLEANUP SOME SILLY DEFAULT RAILS FILES
remove_file 'public/index.html'
remove_file 'public/images/rails.png'
remove_file 'app/views/layouts/application.html.erb'

# KEEP LOG & TMP DIRECTORIES IF EMPTY
create_file 'log/.gitkeep'
create_file 'tmp/.gitkeep'

# CONFIGURE GENERATORS
#   Don't generate stylesheets when scaffolding.
#   Generate factories using the rails3-generator for factory-girl.
#   Don't generate specs for views, controllers, helpers, 
#   or routes in scaffolding.
generators = <<-GENERATORS

    config.generators do |g|
      g.stylesheets false
      g.template_engine :haml
      g.test_framework :rspec
      g.request_specs true
      g.view_specs false
      g.controller_specs false
      g.helper_specs false
      g.routing_specs false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
GENERATORS
application generators

# CREATE A GEMSET FOR THIS PROJECT
run "rvm --create #{RUBY_GEMSET_NAME}"

# Run a command in the scope of the new gemset for this project.
# (Otherwise it will use the wrong rubies.)
def run_in_gemset(command)
  run "rvm #{RUBY_GEMSET_NAME} -S #{command}"
end

# INSTALL GEMS
run_in_gemset "gem install bundler"
run_in_gemset "bundle install"

# CREATE POSTGRES DATABASES
run_in_gemset "rake db:create:all" if USE_POSTGRES

# CONFIGURE GIT AND INITIALIZE A REPOSITORY
git :init
git :add => '.'
git :commit => "-a -q -m 'Initial commit'"