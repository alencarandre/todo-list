class ListDecorator < Draper::Decorator
  delegate_all

  def status_colection
    List::STATUS_VALUES.map do |value|
      [
        List.human_attribute_name("status.#{value}"),
        value
      ]
    end
  end

  def access_type_collection
    List::ACCESS_TYPE_VALUES.map do |value|
      [
        List.human_attribute_name("access_type.#{value}"),
        value
      ]
    end
  end

  def link_to_change_status(screen)
    if model.closed?
      h.list_mark_as_opened_link(model, screen)
    else
      h.list_mark_as_closed_link(model, screen)
    end
  end

  def link_to_favor(screen)
    if model.favorite?(h.current_user)
      h.link_to_unfavor_the_list(model, screen)
    else
      h.link_to_favor_the_list(model, screen)
    end
  end
end
