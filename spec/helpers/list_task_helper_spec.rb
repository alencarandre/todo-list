require 'rails_helper'

RSpec.describe ListTaskHelper, type: :helper do
  let(:task) { FactoryBot.create(:list_task) }

  describe '#list_list_task_mark_as_closed_link' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has link to close list' do
        element = list_list_task_mark_as_closed_link(task)
        href = list_list_task_mark_as_closed_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is public' do
      before(:each) { stub(:controller_name) { 'public'} }

      it 'has not link to close list' do
        element = list_list_task_mark_as_closed_link(task)
        href = list_list_task_mark_as_closed_path(task.list, task)

        expect(element).to_not include("href=\"#{href}\"")
      end

      it 'has only task name' do
        element = list_list_task_mark_as_closed_link(task)

        expect(element).to eq(task.name)
      end
    end
  end

  describe '#list_list_task_mark_as_opened_link' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has link to open list' do
        element = list_list_task_mark_as_opened_link(task)
        href = list_list_task_mark_as_opened_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is public' do
      before(:each) { stub(:controller_name) { 'public'} }

      it 'has not link to open list' do
        element = list_list_task_mark_as_opened_link(task)
        href = list_list_task_mark_as_opened_path(task.list, task)

        expect(element).to_not include("href=\"#{href}\"")
      end

      it 'has only task name' do
        element = list_list_task_mark_as_opened_link(task)

        expect(element).to eq(task.name)
      end
    end
  end

  describe '#edit_list_list_task_link' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has link to open list' do
        element = edit_list_list_task_link(task)
        href = edit_list_list_task_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is public' do
      before(:each) { stub(:controller_name) { 'public' } }

      it 'gives nil' do
        element = edit_list_list_task_link(task)
        expect(element).to be_nil
      end
    end
  end

  describe '#list_list_task_new_link' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has link to open list' do
        element = list_list_task_new_link(task)
        href = list_list_task_new_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is public' do
      before(:each) { stub(:controller_name) { 'public' } }

      it 'gives nil' do
        element = list_list_task_new_link(task)
        expect(element).to be_nil
      end
    end
  end

  describe '#list_list_task_link' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has link to open list' do
        element = list_list_task_link(task)
        href = list_list_task_path(task.list, task)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is public' do
      before(:each) { stub(:controller_name) { 'public' } }

      it 'gives nil' do
        element = list_list_task_link(task)
        expect(element).to be_nil
      end
    end
  end
end
