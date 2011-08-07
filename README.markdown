# Get Setup for Ruby on Rails from Scratch

## Assumptions

I will assume you currently have Mac OSX 10.6, XCode / Developer Kit, Git

## System Setup

### Install rvm:

    mkdir -p ~/.rvm/src/ && cd ~/.rvm/src && rm -rf ./rvm/ && git clone git://github.com/wayneeseguin/rvm.git && cd rvm && ./install

Add the following to your ~/.bashrc:

    # Load RVM
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

Load your .bashrc:

    source ~/.bashrc
    rvm -v

### Install ruby 1.9.2:

    rvm install 1.9.2
    rvm 1.9.2 --default
    ruby -v && rvm list && rvm gemdir && gem -v && gem list

Make gem install not compile rdoc or ri, add the following to ~/.gemrc:
  
    gem: --no-ri --no-rdoc

### Install rails:

    gem install rails
    rails -v

### Install Growl and growlnotify

Go to the [growl homepage](http://growl.info/) and download the dmg. Install both growl, and growlnotify (in the extras directory).

### Install Postgres  

Install with homebrew:

    brew update
    brew install postgres

    initdb /usr/local/var/postgres

For more detailed instructions on this setup, see: https://willj.net/2011/05/31/setting-up-postgresql-for-ruby-on-rails-development-on-os-x/
http://russbrooks.com/2010/11/25/install-postgresql-9-on-os-x

## Create a new rails application

You can now create a new rails app using:

    rails new [app_name] -J -T -m https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/template.rb
    
I'd recommend creating an alias for this. Put this in your ~/.bashrc:

    function rails_template() { rails new "$@" -J -T -m https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/template.rb; }

Now you can create a new app using:

    rails_template [app_name]

## What next?

That's all you need. Go make an awesome rails app! But, you should take a look at my shared [tm_bundles](https://github.com/mitch101/tm_bundles) and [dotfiles](https://github.com/mitch101/tm_bundles) for some tips on how you can pimp your rails experience.