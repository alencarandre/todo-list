require "rails_helper"

feature "Lists::Mine" do
  context 'when user is not logged' do
    scenario 'redirect to login' do
      visit lists_mine_index_path
      expect(page.current_path).to eq(new_user_session_path)
    end
  end

  context 'when user is logged' do
    let(:logged_user) { FactoryBot.create(:user, password: '123456', password_confirmation: '123456')}

    before(:each) do
      visit new_user_session_path
      fill_in 'user_email', with: logged_user.email
      fill_in 'user_password', with: '123456'

      within("div.actions") do
        click_button I18n.t('sign_in')
      end
    end

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

    # context 'when status list is opened' do
    #   let(:logged_user) { FactoryBot.create(:user, password: '123456', password_confirmation: '123456')}
    #
    #   scenario 'add task to list', js: true do
    #     list = FactoryBot.create(:list,
    #                               name: "My List",
    #                               user: logged_user,
    #                               access_type: "personal",
    #                               status: "opened")
    #
    #     visit lists_mine_index_path
    #
    #     within(".task_list:first") do
    #
    #     end
    #   end
    # end

    # context 'when status list is closed' do
    # end
  end
end
