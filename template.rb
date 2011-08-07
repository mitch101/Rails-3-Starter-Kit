# Create a new rails app using:
# => rails new [app] -m https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/template.rb

# For templating commands, see thor docs: http://rdoc.info/github/wycats/thor/master/Thor/Actions#copy_file-instance_method
# and rails specific templating commands at: http://edgeguides.rubyonrails.org/generators.html#generator-methods

@template_path = "https://raw.github.com/mitch101/Rails-3-Starter-Kit/master"

#--------------------------
# BASIC GEMS
#--------------------------

gem 'rails', '3.0.9'
gem 'sqlite3'
gem "haml-rails"
gem "compass"

group :development, :test do
  gem "factory_girl_rails"
  gem "rails3-generators"
  gem "ruby-debug19"
  gem 'spork', '>=0.9.0.rc7'
  gem 'guard'
  gem 'guard-spork'
  gem 'growl'
  gem 'guard-rspec'
  gem 'guard-cucumber'
end

group :test do
  gem "rspec-rails"
  gem "cucumber-rails"
  gem "database_cleaner"
  gem "capybara"
end

#--------------------------
# Remove prototype
#--------------------------
remove_file 'public/javascripts/rails.js'
remove_file 'public/javascripts/controls.js'
remove_file 'public/javascripts/dragdrop.js'
remove_file 'public/javascripts/effects.js'
remove_file 'public/javascripts/prototype.js'

#--------------------------
# Remove test unit
#--------------------------
remove_dir 'test'

#--------------------------
# Configure generators
#--------------------------
# Don't generate stylesheets when scaffolding.
# Generate factories using the rails3-generator for factory-girl.
# Don't generate specs for views, controllers, helpers, requests, or routes in scaffolding.

generators = <<-GENERATORS

    config.generators do |g|
      g.stylesheets false
      g.template_engine :haml
      g.test_framework :rspec
      g.view_specs false
      g.controller_specs false
      g.helper_specs false
      g.routing_specs false
      g.request_specs true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
GENERATORS
application generators

#--------------------------
# Customize default haml application layout
#--------------------------

# Replace the erb application layout with haml one.
# Include jquery hosted by google.
# Include underscore.js.

remove_file "app/views/layouts/application.html.erb"
get "#{@template_path}/application.html.haml", "app/views/layouts/application.html.haml"

#--------------------------
# INSTALL GEMS
#--------------------------
# run 'bundle install'

run 'bundle install'

generate 'rspec:install'
generate 'cucumber:install'

#--------------------------
# Underscore.js
#--------------------------
get "#{@template_path}/underscore-min.js", "public/javascripts/underscore-min.js"

#--------------------------
# POSTGRES
#--------------------------
# Note: pg gem causes trouble with rspec install
# so it has to be loaded after.
if yes?("\r\nInstall with postgres?")
  # Create a database.yml for postgres
  postgres_pass = ask("\r\nEnter your postgres password:")
  remove_file "config/database.yml"
  get "#{@template_path}/database.yml", "config/database.yml"
  gsub_file 'config/database.yml', '[app_name]',"#{app_name}"
  gsub_file 'config/database.yml', '[postgres_pass]',"#{postgres_pass}" 

  # Install pg gem.
  gem 'pg'
  run 'bundle install'
  # Create databases
  rake "db:create:all"
end
  
rake "db:migrate"

#--------------------------
# COMPASS / SASS / Blueprint
#--------------------------

# Install compass
run 'bundle exec compass init rails .'

# Configure application to include blueprint.
remove_file 'app/stylesheets/ie.scss'
get "#{@template_path}/ie.scss", "app/stylesheets/ie.scss"
remove_file 'app/stylesheets/print.scss'
get "#{@template_path}/print.scss", "app/stylesheets/print.scss"
remove_file 'app/stylesheets/screen.scss'
get "#{@template_path}/application.scss", "app/stylesheets/application.scss"
empty_directory 'app/stylesheets/partials'
get "#{@template_path}/_base.scss", "app/stylesheets/partials/_base.scss"

# Include a styleguide accessible at /styleguide.html
get "#{@template_path}/styleguide.html", "public/styleguide.html"

#--------------------------
# CLEANUP
#--------------------------
remove_file 'public/index.html'
remove_file 'public/images/rails.png'

#--------------------------
# GIT
#--------------------------
# Create a standard .gitignore file.
remove_file ".gitignore"
get "#{@template_path}/app_gitignore", ".gitignore"

# Initialize a git repository.
git :init
git :submodule => "init"
git :add => '.'
git :commit => "-a -m 'Initial commit'"