class ListsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user!

  before_action :set_list, only: [:update, :edit, :mark_as_opened, :mark_as_closed]
  before_action :new_list, only: [:new]

  respond_to :js

  def new; end

  def edit; end

  def mark_as_opened
    @list.opened!

    respond_with @list
  end

  def mark_as_closed
    @list.closed!

    respond_with @list
  end

  def mark_as_favorite
    @list = List.shared_lists.find(params[:list_id])
    @list.favor!(current_user)

    respond_with @list
  end

  def mark_as_unfavorite
    @list = current_user.favorites.find(params[:list_id])
    @list.unfavor!(current_user)

    respond_with @list
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    @list.save

    respond_with @list
  end

  def update
    @list.update(list_params)

    respond_with @list
  end

  private

  def list_params
    params.require(:list).permit(:name, :access_type, :status)
  end

  def set_list
    @list = List.by_user(current_user).find(params[:id] || params[:list_id])
  end

  def new_list
    @list = List.new
  end
end
