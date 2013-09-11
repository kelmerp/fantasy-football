class TweetWorker
  # Remember to create a migration!
  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user  = tweet.user

    # set up Twitter OAuth client here
    client = Twitter::Client.new(oauth_token: user.oauth_token,
    oauth_token_secret: user.oauth_secret)
    # actually make API call
    client.update(tweet.tweet_content)
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here
  end

end
