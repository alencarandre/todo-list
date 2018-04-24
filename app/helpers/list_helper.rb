module ListHelper
  def list_mark_as_closed_link(list)
    return list.name if controller_name == 'public'
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
    return list.name if controller_name == 'public'
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
    return if controller_name == 'public'
    link_to(
      content_tag(:i, "", class: "fa fa-pencil"),
      edit_list_path(list),
      class: "edit", data: { remote: true }
    )
  end

  def new_list_list_task_link(list)
    return if controller_name == 'public'
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

  def link_to_favor_the_list(list)
    return if controller_name == 'mine'
    if list.favorite?(current_user)
      link_to(
        content_tag(:i, "", class: "fa fa-star"),
        list_mark_as_unfavorite_path(list),
        title: t("mark_as_unfavorite"),
        data: {
          remote: true,
          toggle: :popover
        }
      )
    else
      link_to(
        content_tag(:i, "", class: "fa fa-star-o"),
        list_mark_as_favorite_path(list),
        title: t("mark_as_favorite"),
        data: {
          remote: true,
          toggle: :popover
        }
      )
    end
  end
end
