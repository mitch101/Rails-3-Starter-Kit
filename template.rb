# Template for creating an awesome rails 3 app!
# See the README for more info.

APP_NAME = app_name
RUBY_NAME = "ruby-1.9.2-p290"
RUBY_GEMSET_NAME = "#{RUBY_NAME}@#{APP_NAME}"
TEMPLATE_PATH = "https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/template/"

def get_template_file(template_file, destination = template_file)
  remove_file destination
  get TEMPLATE_PATH + template_file, destination
end

# CREATE AND USE A PROJECT SPECIFIC GEMSET
run("rvm --create #{RUBY_GEMSET_NAME}")

# INSTALL BUNDLER
run("gem install bundler")

# SETUP RVM TO USE/CREATE PROJECT SPECIFIC GEMSET WHEN CD INTO PROJECT
get_template_file "dot_rvmrc", ".rvmrc"
gsub_file '.rvmrc', '[ruby_name]', "#{RUBY_NAME}"
gsub_file '.rvmrc', '[ruby_gemset_name]', "#{RUBY_GEMSET_NAME}"

# REPLACE THE DEFAULT GEMFILE
get_template_file "Gemfile"

# CONFIGURE GENERATORS
#   Don't generate stylesheets when scaffolding.
#   Generate factories using the rails3-generator for factory-girl.
#   Don't generate specs for views, controllers, helpers, 
#   requests, or routes in scaffolding.
generators = <<-GENERATORS

    config.generators do |g|
      g.stylesheets false
      g.template_engine :haml
      g.test_framework :rspec
      g.request_specs false
      g.view_specs false
      g.controller_specs false
      g.helper_specs false
      g.routing_specs false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
GENERATORS
application generators

# CREATE HAML APPLICATION LAYOUT
#   Replace the erb application layout with haml one.
#   Include jquery hosted by google.
#   Include underscore.js hosted by cdnjs
#   Include compass generated css.
get_template_file "app/views/layouts/application.html.haml"

# INSTALL GEMS
#   Note: We generate bin stubs so that we don't need to use
#   'bundle exec' before gem executables. You should add
#   './bin' to your path so that you can run 'rake', 'cucumber'
#   etc from the Gemfile with ease.
#   See http://yehudakatz.com/2011/05/30/gem-versioning-and-bundler-doing-it-right/
run 'bundle install --binstubs'

# SETUP RSPEC AND CUCUMBER
generate 'rspec:install'
generate 'cucumber:install'

if yes?("\r\nInstall with postgres?")
  # INSTALL POSTGRES
  #   Note: pg gem causes trouble with rspec install so it 
  #   has to be loaded after.
  
  # Create a database.yml for postgres
  postgres_pass = ask("\r\nEnter your postgres password:")
  remove_file "config/database.yml"
  get_template "config/database.yml"
  gsub_file 'config/database.yml', '[app_name]',"#{APP_NAME}"
  gsub_file 'config/database.yml', '[postgres_pass]',"#{postgres_pass}" 
  # Install pg gem.
  gem 'pg'
  run 'bundle install'
  # Create databases
  rake "db:create:all"
end

# MIGRATE THE DATABASE (do I have to do this?)  
rake "db:migrate"

# INSTALL COMPASS
# Create compass config file.
get_template_file "config/compass.rb"
# Setup default sass files.
get_template_file "app/stylesheets/ie.scss"
get_template_file "app/stylesheets/print.scss"
get_template_file "app/stylesheets/application.scss"
get_template_file "app/stylesheets/partials/_base.scss"
# Include a styleguide accessible at /styleguide.html
get_template_file "public/styleguide.html"

# CREATE GUARDFILE
get_template_file "Guardfile"

# CLEANUP SOME SILLY DEFAULT RAILS FILES
remove_file 'public/index.html'
remove_file 'public/images/rails.png'

# CONFIGURE GIT AND INITIALIZE A REPOSITORY
# Create a standard .gitignore file.
get_template_file "dot_gitignore", ".gitignore"
# Initialize a git repository.
git :init
git :submodule => "init"
git :add => '.'
git :commit => "-a -m 'Initial commit'"