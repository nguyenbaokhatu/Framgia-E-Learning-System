class SessionsController < ApplicationController

  def new
    
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to root_url
    else
      flash[:notice] = 'Invalid User Credentials'
      render root_url
    end
  end
  
  def destroy
    logout if logged_in?
    redirect_to root_path
  end

  def google_auth
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    user = User.from_omniauth(access_token)
    log_in(user)
    # Access_token is used to authenticate request made from the rails application to the google server
    user.google_token = access_token.credentials.token
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    user.google_refresh_token = refresh_token if refresh_token.present?
    user.save
    redirect_to root_path
  end

  def google_sign_in
    googleUser = User.from_omniauth(request.env["omniauth.auth"])
    if user = User.find_by(email: googleUser.email)
      login user
      redirect_to root_url
    else
      flash[:notice] = "Email Address does not exist!"
      render 'new'
    end
  end
  
end
