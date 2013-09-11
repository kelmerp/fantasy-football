  class User < ActiveRecord::Base

  has_many :tweets

  def tweet(status)
    tweet = tweets.create!(:tweet_content => status)
    TweetWorker.perform_async(tweet.id)
  end
end