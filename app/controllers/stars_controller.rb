class StarsController < ApplicationController
  before_filter :authenticate_user!, only: [:update, :destroy]

  # Star for the current user
  def update
    @repo = Repository.find_or_initialize_by_name(params[:id])
    current_user.repositories << @repo

    respond_to do |wants|
      wants.json { render json: @repo.to_json(user: current_user) }
    end
  end

  # Unstar for the current user
  def destroy
    @repo = Repository.find_by_name(params[:id])
    current_user.repositories.delete(@repo)

    respond_to do |wants|
      wants.json { render json: @repo.to_json(user: current_user) }
    end
  end
end
