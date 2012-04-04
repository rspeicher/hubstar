class RepositoriesController < ApplicationController
  before_filter :allow_cross_site_origin
  before_filter :authenticate_user!, only: [:index]

  def index
    respond_to do |wants|
      wants.html { redirect_to root_path }
      # TODO: Not final
      wants.json { render json: current_user.repositories.collect { |r| r.name } }
    end
  end

  def show
    @repo  = Repository.find_or_initialize_by_name(params[:id])
    @users = @repo.users_with_priority_to(current_user)

    respond_to do |wants|
      wants.html
      wants.json { render json: @repo.to_json(user: current_user) }
    end
  end
end
