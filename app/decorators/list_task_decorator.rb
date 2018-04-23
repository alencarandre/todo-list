class ListTaskDecorator < Draper::Decorator
  delegate_all

  def link_to_change_status
    if model.closed?
      h.list_list_task_mark_as_opened_link(model)
    else
      h.list_list_task_mark_as_closed_link(model)
    end
  end
end
