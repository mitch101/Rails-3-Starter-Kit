# Get Setup for Ruby on Rails from Scratch

## Assumptions

I will assume you currently have Mac OSX 10.6, XCode / Developer Kit, Git

## Basic Install

### Install rvm:

    $ mkdir -p ~/.rvm/src/ && cd ~/.rvm/src && rm -rf ./rvm/ && git clone git://github.com/wayneeseguin/rvm.git && cd rvm && ./install

Add the following to your ~/.bashrc:

    # Load RVM
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

Load your .bashrc:

    $ source ~/.bashrc
    $ rvm -v

### Install ruby 1.9.2:

    $ rvm install 1.9.2
    $ rvm 1.9.2 --default
    $ ruby -v && rvm list && rvm gemdir && gem -v && gem list

Make gem install not compile rdoc or ri, add the following to ~/.gemrc:
  
    gem: --no-ri --no-rdoc

### Install rails:

    $ gem install rails
    $ rails -v

## Install Postgres  

Install with homebrew:

    brew update
    brew install postgres

    initdb /usr/local/var/postgres

For more detailed instructions on this setup, see: https://willj.net/2011/05/31/setting-up-postgresql-for-ruby-on-rails-development-on-os-x/
http://russbrooks.com/2010/11/25/install-postgresql-9-on-os-x

## Install Textmate Bundles

    $ mkdir -p ~/Library/Application\ Support/TextMate/Bundles/
    $ cd ~/Library/Application\ Support/TextMate/Bundles/

Install rspec textmate bundle:

    $ git clone git://github.com/rspec/rspec-tmbundle.git RSpec.tmbundle

Install Haml textmate bundle:

    $ git clone git://github.com/phuibonhoa/handcrafted-haml-textmate-bundle.git Haml.tmbundle

Install cucumber bundle:

    $ git clone https://github.com/drnic/cucumber-tmbundle Cucumber.tmbundle

Bundles > Bundle Editor > Reload Bundles, in TextMate.

## Create a new rails application

Create a new app by cloning this repository, and running:

    $ rails new [app] -J -T -m https://raw.github.com/mitch101/Rails-3-Starter-Kit/master/template.rb
