class RepositoriesController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :update, :destroy]

  def index
    @repositories = current_user.repositories

    respond_to do |wants|
      wants.html
      # TODO: Not final
      wants.json { render json: @repositories.collect { |r| r.name } }
    end
  end

  def show
    @repo = Repository.find_by_name(params[:id])

    respond_to do |wants|
      wants.html
      wants.json { render json: @repo.to_json(user: current_user) }
    end
  end
end
