module ListAdvertiser
  extend ActiveSupport::Concern

  def notify_change_for list, with:
    old_list = list.as_json
    yield
    notify(list.as_json, old_list, with)
  end

  private

  def notify(new_list, old_list, with)
    data = { list_name: old_list['name'] }
    data[:new_name] = new_list['name'] if with == :updated

    message = {
      message: I18n.t("advertiser.#{with}", data),
      list_id: old_list['id']
    }
    group_ids = old_list['id']

    MessageBus.publish('/list_advertiser', message, group_ids: [ group_ids ])
  end
end
