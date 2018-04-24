require 'rails_helper'
require 'capybara_support'

feature "List actions" do
  include CapybaraSupport

  before(:each) { login(FactoryBot.create(:user)) }

  context 'My Lists' do
    let!(:list) { FactoryBot.create(:list, user: current_user, access_type: :shared) }

    context 'actions to manage list' do
      before(:each) { visit lists_mine_index_path }

      scenario 'show link to edit list' do
        link = "a[href=\"#{edit_list_path(list)}\"]"
        expect(page).to have_selector(link)
      end

      scenario 'show link to add task' do
        link = "a[href=\"#{new_list_list_task_path(list)}\"]"
        expect(page).to have_selector(link)
      end

      scenario 'not show link to mark as favorite' do
        link = "a[href=\"#{list_mark_as_favorite_path(list)}\"]"
        expect(page).to_not have_selector(link)
      end

      scenario 'not show link to remove from favorite' do
        link = "a[href=\"#{list_mark_as_unfavorite_path(list)}\"]"
        expect(page).to_not have_selector(link)
      end
    end

    context 'actions to manage task' do
      let!(:task) { FactoryBot.create(:list_task, list: list) }

      before(:each) { visit lists_mine_index_path }

      scenario 'show link to edit task' do
        link = "a[href=\"#{edit_list_list_task_path(list, task)}\"]"
        expect(page).to have_selector(link)
      end

      scenario 'show link to add sub task' do
        link = "a[href=\"#{list_list_task_new_path(list, task)}\"]"
        expect(page).to have_selector(link)
      end

      scenario 'show link to remove task' do
        link = "a[href=\"#{list_list_task_path(list, task)}\"][data-method=\"delete\"]"
        expect(page).to have_selector(link)
      end
    end
  end

end
