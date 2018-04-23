require 'rails_helper'

RSpec.describe ListTaskHelper, type: :helper do
  let(:task) { FactoryBot.create(:list_task) }

  describe '#list_list_task_mark_as_closed_link' do
    it 'has link to close list' do
      element = list_list_task_mark_as_closed_link(task)
      href = list_list_task_mark_as_closed_path(task.list, task)

      expect(element).to include("href=\"#{href}\"")
    end
  end

  describe '#list_list_task_mark_as_opened_link' do
    it 'has link to open list' do
      element = list_list_task_mark_as_opened_link(task)
      href = list_list_task_mark_as_opened_path(task.list, task)

      expect(element).to include("href=\"#{href}\"")
    end
  end

  describe '#edit_list_list_task_link' do
    it 'has link to open list' do
      element = edit_list_list_task_link(task)
      href = edit_list_list_task_path(task.list, task)

      expect(element).to include("href=\"#{href}\"")
    end
  end

  describe '#list_list_task_new_link' do
    it 'has link to open list' do
      element = list_list_task_new_link(task)
      href = list_list_task_new_path(task.list, task)

      expect(element).to include("href=\"#{href}\"")
    end
  end

  describe '#list_list_task_link' do
    it 'has link to open list' do
      element = list_list_task_link(task)
      href = list_list_task_path(task.list, task)

      expect(element).to include("href=\"#{href}\"")
    end
  end
end
