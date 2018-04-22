class ListTasksController < ApplicationController
  before_action :authenticate_user!

  before_action :set_list, only: [:create, :update, :new, :edit]
  before_action :set_list_task, only: [:update, :edit]
  before_action :new_list_task, only: [:create, :new]

  respond_to :js

  def new; end

  def edit; end

  def create
    @list_task.attributes = list_task_params
    @list_task.save

    respond_with @list, @list_task
  end

  def update
    @list_task.update(list_task_params)

    respond_with @list, @list_task
  end

  private

  def list_task_params
    params.require(:list_task).permit(:name, :status)
  end

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def new_list_task
    @list_task = @list.list_tasks.build
  end

  def set_list_task
    @list_task = @list.list_tasks.find(params[:id])
  end
end
