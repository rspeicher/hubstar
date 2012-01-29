class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :signed_in?

  private

  def current_user
    return nil unless session[:user_id]

    begin
      @current_user ||= User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def authenticate_user!
    unless signed_in?
      respond_to do |wants|
        wants.html { redirect_to sign_in_url, :alert => 'You need to sign in for access to this page.' }
        wants.json { render json: {error: "You must be logged in on HubStar."} }
      end
    end
  end
end