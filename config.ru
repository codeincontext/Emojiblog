require 'rubygems'
require 'sinatra'

set :environment, :production
set :port, 3030
disable :run, :reload

require './emojiblog'

run Sinatra::Application
