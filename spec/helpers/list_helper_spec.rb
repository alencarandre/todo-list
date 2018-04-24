require 'rails_helper'

RSpec.describe ListHelper, type: :helper do
  let(:list) { FactoryBot.create(:list) }

  describe '#list_mark_as_closed_link' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has link to close list' do
        element = list_mark_as_closed_link(list)
        href = list_mark_as_closed_path(list)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is public' do
      before(:each) { stub(:controller_name) { 'public' } }

      it 'has link to close list' do
        element = list_mark_as_closed_link(list)
        href = list_mark_as_closed_path(list)

        expect(element).to_not include("href=\"#{href}\"")
      end

      it 'has only list name' do
        element = list_mark_as_closed_link(list)
        expect(element).to eq(list.name)
      end
    end
  end

  describe '#list_mark_as_opened_link' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has link to open list' do
        element = list_mark_as_opened_link(list)
        href = list_mark_as_opened_path(list)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is public' do
      before(:each) { stub(:controller_name) { 'public' } }

      it 'has link to open list' do
        element = list_mark_as_opened_link(list)
        href = list_mark_as_opened_path(list)

        expect(element).to_not include("href=\"#{href}\"")
      end

      it 'has only list name' do
        element = list_mark_as_opened_link(list)
        expect(element).to eq(list.name)
      end
    end
  end

  describe '#edit_list_link' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has a link to edit list' do
        element = edit_list_link(list)
        href = edit_list_path(list)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is public' do
      before(:each) { stub(:controller_name) { 'public' } }

      it 'gives nil' do
        element = edit_list_link(list)
        expect(element).to be_nil
      end
    end
  end

  describe '#new_list_list_task_path' do
    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has a link to new list' do
        element = new_list_list_task_link(list)
        href = new_list_list_task_path(list)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when controller name is not public' do
      before(:each) { stub(:controller_name) { 'public' } }

      it 'gives nil' do
        element = new_list_list_task_link(list)
        expect(element).to be_nil
      end
    end
  end


end
