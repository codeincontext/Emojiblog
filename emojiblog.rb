require 'sinatra'
require 'mongo'
require 'haml'

configure do
  DB = Mongo::Connection.new['emojiblog']['skattyadz:posts']
end

get '/' do
  selector = {}
  opts = {sort: ['date', :desc]}

  @records = DB.find(selector, opts)
  haml :index
end