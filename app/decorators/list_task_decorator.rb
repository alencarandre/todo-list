class ListTaskDecorator < Draper::Decorator
  delegate_all

  def link_to_change_status(screen)
    if model.closed?
      h.list_list_task_mark_as_opened_link(model, screen)
    else
      h.list_list_task_mark_as_closed_link(model, screen)
    end
  end
end
