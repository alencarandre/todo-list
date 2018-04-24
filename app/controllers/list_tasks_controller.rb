class ListTasksController < ApplicationController
  include ListAdvertiser

  before_action :authenticate_user!


  before_action :set_list
  before_action :set_list_task, only: [:update, :edit, :destroy]
  before_action :new_list_task, only: [:create, :new]

  respond_to :js

  def new; end

  def edit; end

  def mark_as_opened
    @list_task = @list.list_tasks.find(params[:list_task_id])

    notify_change_for @list, with: :opened_task do
      @list_task.opened!

      @list.reload
    end

    respond_with @list, @list_task
  end

  def mark_as_closed
    @list_task = @list.list_tasks.find(params[:list_task_id])

    notify_change_for @list, with: :closed_task do
      @list_task.closed!

      @list.reload
    end

    respond_with @list, @list_task
  end

  def create
    notify_change_for @list, with: :new_task do
      @list_task.attributes = list_task_params
      @list_task.save
    end

    respond_with @list, @list_task
  end

  def update
    notify_change_for @list, with: :update_task do
      @list_task.update(list_task_params)
    end

    respond_with @list, @list_task
  end

  def destroy
    notify_change_for @list, with: :destroy_task do
      @list_task.destroy
    end

    respond_with @list, @list_task
  end

  private

  def list_task_params
    params.require(:list_task).permit(:name, :list_task_id)
  end

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def new_list_task
    @list_task = @list.list_tasks.build
    if params[:list_task_id].present?
      @list_task.list_task_id = params[:list_task_id]
    end
  end

  def set_list_task
    @list_task = @list.list_tasks.find(params[:id])
  end
end
