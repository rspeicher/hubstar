class RepositoriesController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :update, :destroy]

  def index
    headers['Access-Control-Allow-Origin'] = '*' 
    headers['Access-Control-Request-Method'] = '*'

    @repositories = current_user.repositories

    respond_to do |wants|
      wants.html
      # TODO: Not final
      wants.json { render json: @repositories.collect { |r| r.name } }
    end
  end

  def show
    headers['Access-Control-Allow-Origin'] = '*' 
    headers['Access-Control-Request-Method'] = '*'

    @repo = Repository.find_by_name(params[:id])

    respond_to do |wants|
      wants.html
      wants.json { render json: @repo.to_json(user: current_user) }
    end
  end
end
