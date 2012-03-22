class SessionsController < ApplicationController

  def new
    redirect_to '/auth/github'
  end

  def create
    data = request.env["omniauth.auth"][:extra][:raw_info]
    attributes = { :github_data => data, :github_access_token => request.env["omniauth.auth"][:credentials][:token] }
    user = User.find_or_create_by_username(data[:login], attributes)

    session[:user_id] = cookies.permanent.signed[:user_id] = user.id
    flash[:success] = 'Successfully signed in via GitHub!'
    redirect_to root_url
  end

  def destroy
    reset_session
    cookies.delete(:user_id)
    flash[:info] = 'You have been signed out.'
    redirect_to root_url
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
