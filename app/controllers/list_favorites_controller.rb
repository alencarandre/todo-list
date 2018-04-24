class ListFavoritesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_list

  def create
    @favorite = @list.favor!(current_user)
    respond_with @list, @favorite
  end

  def destroy
  end

  private

  def set_list
    @list = List.shared_lists.find(params[:list_id])
  end
end
