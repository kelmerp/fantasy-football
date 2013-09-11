#using twitter account: fakepatmood password:passwordpassword

get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  if !logged_in?
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
    
    @user = User.find_or_create_by_username(username: @access_token.params[:screen_name], 
                                            oauth_token: @access_token.token,
                                            oauth_secret: @access_token.secret)
    session[:user_id] = @user.id
  end

  erb :index
end

get '/status/:job_id' do
  p params
  puts "this happened"
  # return the status of a job to an AJAX call
  {job_status: job_is_complete(params[:job_id])}.to_json
end

post '/tweet' do
  # sleep 5
  # @message = "Your tweet is being process, you'll be notified when it has been sent."
  job_id = current_user.tweet(params[:tweet])
  {job_id: job_id}.to_json
  # erb :index
end

# post '/tweet' do
#   sleep 5
#   begin
#     current_user.tweet(params[:tweet])
#     @message = "Your tweet was sent successfully!"
#     erb :index
#   rescue
#     @error = "Something went wrong, sorry!  You know you can't tweet the same \
#     thing twice, right?"
#     erb :index
#   end
# end
