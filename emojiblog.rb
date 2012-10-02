require 'daemons'
require 'sinatra'
require 'mongo'
require 'haml'

@base_name = 'emojiblog'
pwd = Dir.pwd
file = pwd + '/emojiblog.rb'

Daemons.run_proc(
  'emojiblog', # name of daemon
#  :dir_mode => :normal
#  :dir => File.join(pwd, 'tmp/pids'), # directory where pid file will be stored
  :multiple => false,
  :backtrace => true,
  :monitor => true,
  :log_output => true
) do
  Dir.chdir(pwd)

  configure do
    DB = Mongo::Connection.new['emojiblog']['skattyadz:posts']
  end

  get '/' do
    selector = {}
    opts = {sort: ['date', :desc]}

    @records = DB.find(selector, opts)
    haml :index
  end
  
end