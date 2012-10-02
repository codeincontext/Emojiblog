require 'em-mongo'
require 'yaml'
require 'tweetstream'
require 'active_support/core_ext/time/calculations'
require 'date'
  
class TwitterListener
  def initialize
    pwd  = File.dirname(File.expand_path(__FILE__))
    file = pwd + "/config.yaml"
    @config = YAML.load_file(file)
    TweetStream.configure do |c|
      c.consumer_key       = @config["twitter"]["consumer_key"]
      c.consumer_secret    = @config["twitter"]["consumer_secret"]
      c.oauth_token        = @config["twitter"]["oauth_token"]
      c.oauth_token_secret = @config["twitter"]["oauth_token_secret"]
    end
  end  

  def start
    client = TweetStream::Client.new
  
    client.on_error do |m|
      puts "Error: #{m})", !m.include?("duplicate")
    end.on_reconnect do |t, r|
      puts "Reconnect: timout:#{t} retries:#{r})"
    end.on_unauthorized do
      puts "Unauthorised"
    end.on_inited do
      puts "Listening"
    end.on_no_data_received do
      puts "Stalled"
    end.track("@emoji_blog") do |status|
      if status.text.match(/^@emoji_blog/) and status.user.screen_name == 'skattyadz'
        add_post status
      end
    end
  end
  
private
  def add_post(status)
    puts "Adding post: #{status.text}"
    
    text = status.text.gsub '@emoji_blog ', ''
    text_parts = text.split '|'
      
    COLLECTION.insert({
      date: Time.now.utc,
      title: text_parts[0],
      content: text_parts[1]
    })
    
    post_tweet text_parts[1]
  end
  
  def post_tweet(content)
    tweet_text = "#{content} http://emojiblog.skatty.me"
    twitter_client.update tweet_text
  end
  
  def twitter_client
    @twitter_client ||= Twitter::Client.new(
      consumer_key:       @config["twitter"]["consumer_key"],
      consumer_secret:    @config["twitter"]["consumer_secret"],
      oauth_token:        @config["twitter"]["oauth_token"],
      oauth_token_secret: @config["twitter"]["oauth_token_secret"]
    )
  end
end