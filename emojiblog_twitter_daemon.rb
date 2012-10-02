require 'daemons'
require 'em-mongo'

require_relative 'emojiblog_twitter'
@base_name = 'emojiblog_twitter'

Daemons.run_proc(
  'emojiblog_twitter', # name of daemon
#  :dir_mode => :normal
#  :dir => File.join(pwd, 'tmp/pids'), # directory where pid file will be stored
  :multiple => false,
  :backtrace => true,
  :monitor => true,
  :log_output => true
) do
  EventMachine.run do
    db = EM::Mongo::Connection.new('localhost').db('emojiblog')
    COLLECTION = db.collection('skattyadz:posts')
    TwitterListener.new.start
  end
end