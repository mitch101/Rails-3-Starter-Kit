# Create a new rails app using:
# => rails new [app] -J -T -m https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/template.rb

# For templating commands, see thor docs: http://rdoc.info/github/wycats/thor/master/Thor/Actions#copy_file-instance_method
# and rails specific templating commands at: http://edgeguides.rubyonrails.org/generators.html#generator-methods

@template_path = "https://raw.github.com/mitch101/Rails-3-Starter-Kit/master"

#--------------------------
# BASIC GEMS
#--------------------------
gem "ruby-debug", :group => [:development, :test]
gem "awesome_print", :group => [:development, :test]
gem "rspec-rails", "2.5.0", :group => [:development, :test]
gem 'cucumber-rails', "0.4.0", :group => :test
gem 'database_cleaner', :group => :test
gem 'capybara', "0.4.1.2", :group => :test
gem "annotate-models", :group => :development
gem 'metrical', :group => :development
#gem 'rake', "0.8.7" # There was a bug in 1.9 rake with rails, however forcing version here makes you use bundle exec rake, which isn't nice.
gem "rails3-generators", :group => [:development, :test]
gem "factory_girl_rails", "1.0.1", :group => [:development, :test]
gem "haml-rails", ">= 0.3.4"
gem "compass", ">= 0.11.3"

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
      g.request_specs false
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

layout = <<-LAYOUT
!!!
%html
  %head
    %title #{app_name.humanize}  
    = stylesheet_link_tag 'screen.css', :media => 'screen, projection'
    = stylesheet_link_tag 'print.css', :media => 'print'
    /[if lt IE 8]
      = stylesheet_link_tag 'ie.css', :media => 'screen, projection'          
    = javascript_include_tag 'https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js', 'underscore-min'
    = csrf_meta_tag
  %body
    = yield
LAYOUT
remove_file "app/views/layouts/application.html.erb"
get "#{@template_path}/application.html.haml", "app/views/layouts/application.html.haml"

#--------------------------
# INSTALL GEMS
#--------------------------
# run 'bundle install'
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
  create_file "config/database.yml", <<-DATABASE
development:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_development
  pool: 5
  username: postgres
  password: #{postgres_pass}

test:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_test
  pool: 5
  username: postgres
  password: #{postgres_pass}

production:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_production
  pool: 5
  username: postgres
  password: #{postgres_pass}
DATABASE
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
run 'bundle exec compass init rails .'



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
create_file '.gitignore', <<-FILE
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
public/uploads/*
gems/*
!gems/cache
!gems/bundler
FILE
# Initialize a git repository.
git :init
git :submodule => "init"
git :add => '.'
git :commit => "-a -m 'Initial commit'"