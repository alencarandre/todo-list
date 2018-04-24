require 'rails_helper'

RSpec.describe ListTaskHelper, type: :helper do
  let(:task) { FactoryBot.create(:list_task) }

  describe '#list_task_mark_as_closed_link' do
    context 'when pass screen :mine' do
      it 'has link to close list' do
        element = list_task_mark_as_closed_link(task, :mine)
        href = list_list_task_mark_as_closed_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'has not link to close list' do
        element = list_task_mark_as_closed_link(task, :public)
        href = list_list_task_mark_as_closed_path(task.list, task)

        expect(element).to_not include("href=\"#{href}\"")
      end

      it 'has only task name' do
        element = list_task_mark_as_closed_link(task, :public)

        expect(element).to eq(task.name)
      end
    end
  end

  describe '#list_task_mark_as_opened_link' do
    context 'when pass screen :mine' do
      it 'has link to open list' do
        element = list_task_mark_as_opened_link(task, :mine)
        href = list_list_task_mark_as_opened_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'has not link to open list' do
        element = list_task_mark_as_opened_link(task, :public)
        href = list_list_task_mark_as_opened_path(task.list, task)

        expect(element).to_not include("href=\"#{href}\"")
      end

      it 'has only task name' do
        element = list_task_mark_as_opened_link(task, :public)

        expect(element).to eq(task.name)
      end
    end
  end

  describe '#edit_list_task_link' do
    context 'when pass screen :mine' do
      it 'has link to open list' do
        element = edit_list_task_link(task, :mine)
        href = edit_list_list_task_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'gives nil' do
        element = edit_list_task_link(task, :public)
        expect(element).to be_nil
      end
    end
  end

  describe '#new_list_sub_task_link' do
    context 'when pass screen :mine' do
      it 'has link to open list' do
        element = new_list_sub_task_link(task, :mine)
        href = list_list_task_new_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'gives nil' do
        element = new_list_sub_task_link(task, :public)
        expect(element).to be_nil
      end
    end
  end

  describe '#destroy_list_task_link' do
    context 'when pass screen :mine' do
      it 'has link to open list' do
        element = destroy_list_task_link(task, :mine)
        href = list_list_task_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'gives nil' do
        element = destroy_list_task_link(task, :public)
        expect(element).to be_nil
      end
    end
  end
end
