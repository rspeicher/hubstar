class RepositoriesController < ApplicationController
  before_filter :require_user_for_json, :only => [:index]

  def index
    respond_to do |wants|
      wants.json { render :json => current_user.repositories.collect { |r| r.name } }
    end
  end

  def show
    @repo = Repository.find_by_name(params[:id])

    respond_to do |wants|
      wants.html
      wants.json { render :json => @repo.to_json(:user => current_user) }
    end
  end

  protected

  def require_user_for_json
    respond_to do |wants|
      wants.json { render json: {error: "You must be logged in on HubStar."} unless signed_in? }
    end
  end
end
