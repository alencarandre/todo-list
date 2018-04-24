module ListTaskHelper
  def list_task_mark_as_closed_link(task, screen)
    return task.name if screen != :mine
    link_to(
      task.name,
      list_list_task_mark_as_closed_path(task.list, task),
      title: t("mark_as_closed"),
      data: {
        remote: true,
        toggle: :popover
      }
    )
  end

  def list_task_mark_as_opened_link(task, screen)
    return task.name if screen != :mine
    link_to(
      task.name,
      list_list_task_mark_as_opened_path(task.list, task),
      title: t("mark_as_opened"),
      data: {
        remote: true,
        toggle: :popover
      }
    )
  end

  def edit_list_task_link(task, screen)
    return if screen != :mine
    link_to(
      content_tag(:i, "", class: "fa fa-pencil"),
      edit_list_list_task_path(task.list, task),
      title: t("edit_task"),
      data: {
        remote: true,
        toggle: :popover
      }
    )
  end

  def new_list_sub_task_link(task, screen)
    return if screen != :mine

    link_to(
      content_tag(:i, "", class: "fa fa-plus"),
      list_list_task_new_path(task.list, task),
      title: t("new_task"),
      data: {
        remote: true,
        toggle: :popover
      }
    )
  end

  def destroy_list_task_link(task, screen)
    return if screen != :mine

    link_to(
      content_tag(:i, "", class: "fa fa-trash"),
      list_list_task_path(task.list, task),
      title: t("delete_task"),
      method: :delete,
      data: {
        confirm: t("are_you_sure"),
        remote: true,
        toggle: :popover
      }
    )
  end
end
