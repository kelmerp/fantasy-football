#using twitter account: fakepatmood password:passwordpassword

get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  if !logged_in?
    # rrake  edirect request_token.authorize_url
  else
    redirect "/"
  end
end

get '/sign_out' do
  session.clear
  redirect '/'
end

# get '/auth' do
#   if !logged_in?
#     # the `request_token` method is defined in `app/helpers/oauth.rb`
#     @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
#     # our request token is only valid until we use it to get an access token, so let's delete it from our session
#     session.delete(:request_token)
    
#     @user = User.find_or_create_by_username(username: @access_token.params[:screen_name], 
#                                             oauth_token: @access_token.token,
#                                             oauth_secret: @access_token.secret)
#     session[:user_id] = @user.id
#   end

#   erb :index
# end
