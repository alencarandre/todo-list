require 'rails_helper'

describe ListTaskDecorator, type: :model do

  describe '#link_to_change_status' do
    context 'when pass screen == :mine' do
      context 'when list status is opened' do
        subject { FactoryBot.create(:list_task, status: :opened).decorate }

        it 'gives link to mark as closed' do
          element = subject.link_to_change_status(:mine)
          href = list_list_task_mark_as_closed_path(subject.model.list, subject.model)

          expect(element).to include("href=\"#{href}\"")
        end
      end

      context 'when list status is closed' do
        subject { FactoryBot.create(:list_task, status: :closed).decorate }

        it 'gives link to mark as opened' do
          element = subject.link_to_change_status(:mine)
          href = list_list_task_mark_as_opened_path(subject.model.list, subject.model)

          expect(element).to include("href=\"#{href}\"")
        end
      end
    end
  end

  context 'when pass screen == :public' do
    [:opened, :closed].each do |status|
      subject { FactoryBot.create(:list_task, status: status).decorate }

      it 'gives task name' do
        element = subject.link_to_change_status(:public)
        expect(element).to eq(subject.model.name)
      end
    end
  end

end
