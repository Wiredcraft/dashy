require 'twitter'
 
Twitter.configure do |config|
  config.consumer_key = 'iiMDnP3srvaScbQovtCHw'
  config.consumer_secret = 'MMSHelvmdet8wBKAFOTXl41ZBEfIpLSRm3OPms'
  config.oauth_token = '1252639880-4DUAJJhC2tNUxoRF9WTHjvyeOBd68dW87Wn1RxN'
  config.oauth_token_secret = 'hJfvOF34vR5mVxEhU9KMq8cCY6Y4wCx8k8jwh10ZpHg'
end
 
search_term = URI::encode('@wiredcraft')
 
SCHEDULER.every '60s', :first_in => 0 do |job|
  tweets = Twitter.search("#{search_term}").results
  if tweets
    tweets.map! do |tweet|
      { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
    end
    send_event('twitter_mentions', comments: tweets)
  end
end