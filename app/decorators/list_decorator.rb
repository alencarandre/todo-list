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
end
