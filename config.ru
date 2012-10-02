require 'rubygems'
require 'sinatra'

set :environment, :production
set :port, 8000
disable :run, :reload

require 'emojiblog'

run Sinatra::Application