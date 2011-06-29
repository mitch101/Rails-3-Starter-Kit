# Create a new rails app using:
# => rails new [app] -J -T -m /path/to/this/file

@template_path = "#{File.dirname(__FILE__)}"

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
gem 'rake', "0.8.7"
gem "rails3-generators", :group => [:development, :test]
gem "factory_girl_rails", "1.0.1", :group => [:development, :test]
gem "haml-rails", ">= 0.3.4"

#--------------------------
# Configure generators
#--------------------------

# Don't generate stylesheets when scaffolding.
# Generate factories using the rails3-generator for factory-girl.
# Don't generate specs for views, controllers, helpers, or routes in scaffolding.

generators = <<-GENERATORS

    config.generators do |g|
      g.stylesheets false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.controller-specs false
      g.view-specs false
      g.helper-specs false
      g.routing-specs false
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
    = stylesheet_link_tag 'blueprint-css-1.0/screen.css', :media => 'screen, projection'
    = stylesheet_link_tag 'blueprint-css-1.0/print.css', :media => 'print'
    /[if lt IE 8]
      = stylesheet_link_tag 'blueprint-css-1.0/ie.css', :media => 'screen, projection'
    = javascript_include_tag 'https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js', 'underscore'
    = csrf_meta_tag
  %body
    .container
      = yield
LAYOUT
remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml", layout

#--------------------------
# INSTALL GEMS
#--------------------------
run 'bundle install'
generate 'jquery:install'
generate 'rspec:install'
generate 'cucumber:install'

#--------------------------
# Underscore.js
#--------------------------
run "cp -r #{@template_path}/underscore-min.js public/javascripts"

#--------------------------
# BLUEPRINT-CSS
#--------------------------
run "cp -r #{@template_path}/blueprint-css-1.0 public/stylesheets"

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