# Create a new rails app using:
# => rails new [app] -m https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/template.rb

# For templating commands, see thor docs: http://rdoc.info/github/wycats/thor/master/Thor/Actions#copy_file-instance_method
# and rails specific templating commands at: http://edgeguides.rubyonrails.org/generators.html#generator-methods

@template_path = "https://raw.github.com/mitch101/Rails-3-Starter-Kit/master"

# DEFINE DEFAULT GEMS TO INCLUDE
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

# REMOVE PROTOTYPE
remove_file 'public/javascripts/rails.js'
remove_file 'public/javascripts/controls.js'
remove_file 'public/javascripts/dragdrop.js'
remove_file 'public/javascripts/effects.js'
remove_file 'public/javascripts/prototype.js'

# REMOVE TEST UNIT
remove_dir 'test'

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

# CREATE HAML APPLICATION LAYOUT
#   Replace the erb application layout with haml one.
#   Include jquery hosted by google.
#   Include underscore.js hosted by cdnjs
#   Include compass generated css.
remove_file "app/views/layouts/application.html.erb"
get "#{@template_path}/application.html.haml", "app/views/layouts/application.html.haml"

# INSTALL GEMS
run 'bundle install'

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
  get "#{@template_path}/database.yml", "config/database.yml"
  gsub_file 'config/database.yml', '[app_name]',"#{app_name}"
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
# Install config files that 'compass init rails .' would generate.
get "#{@template_path}/config_compass.rb", "config/compass.rb"
get "#{@template_path}/initializers_compass.rb", "config/initializers/compass.rb"
# Setup default sass files.
empty_directory "app/stylesheets"
empty_directory "app/stylesheets/partials"
get "#{@template_path}/ie.scss", "app/stylesheets/ie.scss"
get "#{@template_path}/print.scss", "app/stylesheets/print.scss"
get "#{@template_path}/application.scss", "app/stylesheets/application.scss"
get "#{@template_path}/_base.scss", "app/stylesheets/partials/_base.scss"
# Include a styleguide accessible at /styleguide.html
get "#{@template_path}/styleguide.html", "public/styleguide.html"

# CLEANUP SOME SILLY DEFAULT RAILS FILES
remove_file 'public/index.html'
remove_file 'public/images/rails.png'

# CONFIGURE GIT AND INITIALIZE A REPOSITORY
# Create a standard .gitignore file.
remove_file ".gitignore"
get "#{@template_path}/app_gitignore", ".gitignore"
# Initialize a git repository.
git :init
git :submodule => "init"
git :add => '.'
git :commit => "-a -m 'Initial commit'"