# Setup the perfect ruby on rails rpp from scratch

TODO: Add flutie for nice stylesheets out of the box.

I will assume you currently have Mac OSX 10.6, XCode / Developer Kit, Git, Growl, Textmate.

## Basic Install

### Install rvm:

    $ mkdir -p ~/.rvm/src/ && cd ~/.rvm/src && rm -rf ./rvm/ && git clone git://github.com/wayneeseguin/rvm.git && cd rvm && ./install

Add the following to your ~/.profile:

    # Load RVM
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

Load your .profile:

    $ source ~/.profile
    $ rvm -v
    $ rvm list

### Install ruby 1.8.7:

    $ rvm install 1.8.7
    $ rvm 1.8.7 --default
    $ ruby -v
    $ rvm list
    $ rvm gemdir
    $ gem -v
    $ gem list

Make gem install not compile rdoc or ri, add the following to ~/.gemrc:
  
    gem: --no-ri --no-rdoc

### Install rails:

    $ gem install rails
    $ rails -v

## Postgres Setup


### Install Postgres:

Get the [one click installer](http://www.postgresql.org/download/macosx) (> v 9.0.3), and run the app inside the dmg. (Note: I had to restart my system and re-run the installer). Use the default settings, set the password to postgres. Don't run stack builder at the end.

Add the following to your ~/.profile:

    # Add Postgres binaries to the path
    export PATH=$PATH:/Library/PostgreSQL/9.0/bin

Reload your ~/.profile:

    $ source ~/.profile

## Pimp Your Console

Add awesome printing (colors and formatting of console output)

Add to Gemfile in each rails app:

    group :development, :test do
      gem 'awesome_print'
    end

Try it in rails console:
    $ ap { :a => 1, :b => 2 }

Nice console prompt, logging to console, console indenting

Setup your ~.irbrc to look like:

    %w{rubygems}.each do |lib| 
      begin 
        require lib 
      rescue LoadError => err
        $stderr.puts "Couldn't load #{lib}: #{err}"
      end
    end

    # Prompt behavior
    IRB.conf[:AUTO_INDENT] = true

    # Loaded when we fire up the Rails console
    # => Set a special rails prompt.
    # => Redirect logging to STDOUT.   
    if defined?(Rails.env)
      rails_env = Rails.env
      rails_root = File.basename(Dir.pwd)
      prompt = "#{rails_root}[#{rails_env.sub('production', 'prod').sub('development', 'dev')}]"
      IRB.conf[:PROMPT] ||= {}
      IRB.conf[:PROMPT][:RAILS] = {
        :PROMPT_I => "#{prompt}>> ",
        :PROMPT_S => "#{prompt}* ",
        :PROMPT_C => "#{prompt}? ",
        :RETURN   => "=> %s\n" 
      }
      IRB.conf[:PROMPT_MODE] = :RAILS
      # Redirect log to STDOUT, which means the console itself
      IRB.conf[:IRB_RC] = Proc.new do
        logger = Logger.new(STDOUT)
        ActiveRecord::Base.logger = logger
        ActiveResource::Base.logger = logger
        ActiveRecord::Base.instance_eval { alias :[] :find }
      end
    end

## Create the perfect rails app.

template.rb will create an app with the following features:

* rspec with generators working
* factory_girl with generators working loaded in rspec
* jquery replacing prototype and included in the default layout
* haml with generators working, and replacing default layout with a haml layout.
* postgres configured (optional, with provided password)
* cucumber with capybara for integration testing.
* ruby debug
  * debug app using "rails s --debug", and add "debugger" in code
* awesome_print
  * use "ap" in console
* annotate-models
  * show model attributes by running "annotate"
* a good .gitignore file
* initalize and commit a git repository
* clean up of some unused rails files.

Create a new app by running:

    $ rails new [myapp] -J -T -m /path/to/template.rb

No additional setup tasks required.
    
## Bonus Setup

### Install Textmate Bundles

Install rspec textmate bundle (for syntax highlighting and running of an open test file in tm using cmd-r with a nice html output). Follow the instuctions [here](http://rspec.info/documentation/tools/extensions/editors/textmate.html), or [here](http://stackoverflow.com/questions/3532538/installing-rspec-bundle-for-textmate)

Install Haml textmate bundle...?

### Install Autotest and Spork for fast, continuous testing

First, make sure you have growl installed and running on login.

    $ gem install autotest-standalone
    $ gem install autotest-fsevent
    $ gem install autotest-growl

Setup autotest to use fsevent and growl. Create ~/.autotest with:
  	require 'autotest/fsevent'
  	require 'autotest/growl'

Make sure you have growl configured to accept the autotest application.

Run autotest:
    $ autotest

It will watch for changes to specs and source code of all your apps and run any required tests.

Install spork to increase your test speed. Follow the instructions [here](
http://www.rubyinside.com/how-to-rails-3-and-rspec-2-4336.html).

### Load jQuery and jQuery-UI from google

See: 

    http://code.google.com/apis/libraries/devguide.html 

and add script tags to load the desired libraries. Remove :defaults, and add the scripts you want to load manually.

jquery-ui css is hosted at:
      
      http://ajax.googleapis.com/ajax/libs/jqueryui/[UI.VERSION]/themes/[THEME-NAME]/jquery-ui.css




