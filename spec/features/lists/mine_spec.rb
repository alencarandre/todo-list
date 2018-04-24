require "rails_helper"
require 'capybara_support'

feature "Lists::Mine" do
  include CapybaraSupport

  context 'when user is not logged' do
    scenario 'redirect to login' do
      visit lists_mine_index_path
      expect(page.current_path).to eq(new_user_session_path)
    end
  end

  context 'when user is logged' do
    let(:logged_user) { FactoryBot.create(:user,
                                          password: '123456',
                                          password_confirmation: '123456')}

    before(:each) { login(logged_user) }

    scenario 'is able to create new empty list', js: true do
      visit lists_mine_index_path

      click_on I18n.t("new_list")

      fill_in "list_name", with: "My new wonderful list"

      select(
        List.human_attribute_name("access_type.personal"),
        from: "list_access_type"
      )

      select(
        List.human_attribute_name("status.opened"),
        from: "list_status"
      )

      click_button I18n.t("save")

      expect(page).to have_content("My new wonderful list")
    end

    scenario 'is able to edit list', js: true do
      list = FactoryBot.create(:list,
                                name: "My List",
                                user: logged_user,
                                access_type: "personal",
                                status: "opened")

      visit lists_mine_index_path

      find("a[href='" + edit_list_path(list) + "']").click

      fill_in "list_name", with: "My list (edited)"

      click_button I18n.t("save")

      expect(page).to have_content("My list (edited)")
    end

    context 'when status list is opened' do
      let!(:list) { FactoryBot.create(:list,
                                      name: "My List",
                                      user: logged_user,
                                      access_type: "personal",
                                      list_tasks: [],
                                      status: "opened")}

      scenario 'add task to list', js: true do
        visit lists_mine_index_path

        selector = "a[href='" + new_list_list_task_path(list_id: list.id) + "']"
        find(selector).click

        fill_in "list_task_name", with: "My new Task"

        click_button I18n.t("save")

        expect(page).to have_content("My new Task")
      end

      scenario 'edit task', js: true do
        task = FactoryBot.create(:list_task, list: list, name: "Task")

        visit lists_mine_index_path

        selector = "a[href='" + edit_list_list_task_path(list_id: list.id, id: task.id) + "']"
        find(selector).click

        fill_in "list_task_name", with: "Task (edited)"

        click_button I18n.t("save")

        expect(page).to have_content("Task (edited)")
      end
    end

  end
end
