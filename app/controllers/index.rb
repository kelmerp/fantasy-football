#using twitter account: fakepatmood password:passwordpassword

get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  if !signed_in?
    redirect request_token.authorize_url
  else
    redirect "/"
  end
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  if !logged_in?
    # the `request_token` method is defined in `app/helpers/oauth.rb`
    @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    # our request token is only valid until we use it to get an access token, so let's delete it from our session
    session.delete(:request_token)

    # at this point in the code is where you'll need to create your user account and store the access token
    
    #<OAuth::AccessToken:0x007fe2cbb5dfa0 @token="1578293246-UJyL7DftALHb4VAyi5JozxqjMlI6wwtbx7JRBi8",
    # @secret="tOVbjd8VjU77RerEXHFJTiqaG7lE76u4ZGQtwExK7R4",
    # @consumer=#<OAuth::Consumer:0x007fe2cbb98628 @key="QpCKEfP0eQImD7GaUdfdw",
    # @secret="JtxnHqUxZQ6fI4T4HFofZa2X1qZCvB2CHkouVuVMI", 
    #@options={:signature_method=>"HMAC-SHA1", :request_token_path=>"/oauth/request_token",
    # :authorize_path=>"/oauth/authorize", :access_token_path=>"/oauth/access_token",
    # :proxy=>nil, :scheme=>:header, :http_method=>:post, :oauth_version=>"1.0",
    # :site=>"https://api.twitter.com"}, @http_method=:post,
    # @http=#<Net::HTTP api.twitter.com:443 open=false>>,
    # @params={:oauth_token=>"1578293246-UJyL7DftALHb4VAyi5JozxqjMlI6wwtbx7JRBi8",
    # "oauth_token"=>"1578293246-UJyL7DftALHb4VAyi5JozxqjMlI6wwtbx7JRBi8",
    # :oauth_token_secret=>"tOVbjd8VjU77RerEXHFJTiqaG7lE76u4ZGQtwExK7R4",
    # "oauth_token_secret"=>"tOVbjd8VjU77RerEXHFJTiqaG7lE76u4ZGQtwExK7R4",
    # :user_id=>"1578293246", "user_id"=>"1578293246", :screen_name=>"fakepatmood",
    # "screen_name"=>"fakepatmood"}>
    
    @user = User.find_or_create_by_username(username: @access_token.params[:screen_name], 
                                            oauth_token: @access_token.token,
                                            oauth_secret: @access_token.secret)
    session[:user_id] = @user.id
  end

  erb :index
end


post '/tweet' do
  client = Twitter::Client.new(oauth_token: current_user.oauth_token,
   oauth_token_secret: current_user.oauth_secret)
  client.update(params[:tweet])
  erb :index
end
