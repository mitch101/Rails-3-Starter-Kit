# Create a new rails app using:
# => rails new [app] -J -T -m https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/template.rb

# For templating commands, see thor docs: http://rdoc.info/github/wycats/thor/master/Thor/Actions#copy_file-instance_method
# and rails specific templating commands at: http://edgeguides.rubyonrails.org/generators.html#generator-methods

RUBY_VERSION = "ruby-1.9.2-p290"
TEMPLATE_PATH = "https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/"

def get_template(template_file, *destination)
  get TEMPLATE_PATH + template_file, destination
end

# SETUP RVM TO CREATE PROJECT SPECIFIC GEMSET
get_template "dot_rvmrc", ".rvmrc"
gsub_file '.rvmrc', '[app_name]', "#{app_name}"
gsub_file '.rvmrc', '[ruby_version]', "#{RUBY_VERSION}"

# REPLACE THE DEFAULT GEMFILE
remove_file "Gemfile"
get_template "Gemfile", "Gemfile"

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
remove_file "app/views/layouts/application.html.erb"
get_template "application.html.haml", "app/views/layouts/application.html.haml"

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
  get_template "database.yml", "config/database.yml"
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
# Create compass config file.
get_template "compass.rb", "config/compass.rb"
# Setup default sass files.
empty_directory "app/stylesheets"
empty_directory "app/stylesheets/partials"
get_template "ie.scss", "app/stylesheets/ie.scss"
get_template "print.scss", "app/stylesheets/print.scss"
get_template "application.scss", "app/stylesheets/application.scss"
get_template "_base.scss", "app/stylesheets/partials/_base.scss"
# Include a styleguide accessible at /styleguide.html
get_template "styleguide.html", "public/styleguide.html"

# CREATE GUARDFILE
get_template "Guardfile", "Guardfile"

# CLEANUP SOME SILLY DEFAULT RAILS FILES
remove_file 'public/index.html'
remove_file 'public/images/rails.png'

# CONFIGURE GIT AND INITIALIZE A REPOSITORY
# Create a standard .gitignore file.
remove_file ".gitignore"
get_template "dot_gitignore", ".gitignore"
# Initialize a git repository.
git :init
git :submodule => "init"
git :add => '.'
git :commit => "-a -m 'Initial commit'"