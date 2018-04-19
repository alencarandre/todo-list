class ListsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_list, only: [:update]

  respond_to :js

  def index; end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    @list.save

    respond_with @list
  end

  def update
    @list = List.find(params[:id])
    @list.update(list_params)

    respond_with @list
  end

  private

  def list_params
    params.require(:list).permit(:name, :access_type)
  end

  def set_list
    @list = List.by_user(current_user).find(params[:id])
  end
end
