require 'rubygems'
require 'sinatra'
require 'raven'

require File.expand_path '../app.rb', __FILE__

Raven.configure do |config|
  config.server = ENV['APP_RAVEN_DSN']
end

use Raven::Rack
run BoardingApp
