module ListHelper
  def list_mark_as_closed_link(list)
    link_to(
      list.name,
      list_mark_as_closed_path(list_id: list.id),
      title: t("mark_as_closed"),
      data: {
        remote: true,
        toggle: :popover
      }
    )
  end

  def list_mark_as_opened_link(list)
    link_to(
      list.name,
      list_mark_as_opened_path(list_id: list.id),
      title: t("mark_as_opened"),
      data: {
        remote: true,
        toggle: :popover
      }
    )
  end

  def edit_list_link(list)
    link_to(
      content_tag(:i, "", class: "fa fa-pencil"),
      edit_list_path(list),
      class: "edit", data: { remote: true }
    )
  end

  def new_list_list_task_link(list)
    link_to(
      content_tag(:i, "", class: "fa fa-plus"),
      new_list_list_task_path(list_id: list.id),
      title: t("new_task"),
      data: {
        remote: true,
        toggle: :popover
      }
    )
  end
end
