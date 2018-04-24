class ListsController < ApplicationController
  include ListAdvertiser

  before_action :authenticate_user!

  before_action :set_list, only: [:update, :edit, :destroy,
                                  :mark_as_opened, :mark_as_closed]
  before_action :new_list, only: [:new]

  respond_to :js

  def new; end

  def edit; end

  def mark_as_opened
    notify_change_for @list, with: :opened do
      @list.opened!
    end

    respond_with @list
  end

  def mark_as_closed
    notify_change_for @list, with: :closed do
      @list.closed!
    end

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
    notify_change_for @list, with: :updated do
      @list.update(list_params)
    end

    respond_with @list
  end

  def destroy
    @list.destroy
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
