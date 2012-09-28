require 'sinatra'
require 'json'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/time/calculations'
require 'date'
require 'mongo'
require 'haml'

configure do
  enable :sessions
  set :session_secret, 'orgnsorgjr9fer9f8'
  
  DB = Mongo::Connection.new['emojiblog']['skattyadz:posts']
end

get '/' do
  selector = {}
  opts = {sort: ['time', :desc]}
  
  # html = ''
  # DB.find(selector, opts).inject(html) do |result, document|
  #   date = document['date'].strftime("%B %d")   
  #   result + "<h2><span class='date'>#{date}</span> - #{document['title']}</h2><p>#{document['content']}</p>"
  # end
  @records = DB.find(selector, opts)
  haml :index
end

get '/supersecretentrypage' do
  haml :new
end

post '/supersecretentrypage' do
  DB.insert({
    date: Time.now.utc.midnight,
    title: params['title'],
    content: params['content']
  })
  
  haml :index
end