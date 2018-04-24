require 'rails_helper'
require 'capybara_support'

feature 'Public Lists' do
  include CapybaraSupport

  context 'when user is not logged' do
    scenario 'redirect to login' do
      visit lists_public_index_path
      expect(page.current_path).to eq(new_user_session_path)
    end
  end

  context 'when user is logged' do
    let(:logged_user) { FactoryBot.create(:user) }

    before(:each) { login(logged_user) }

    let!(:public_list) { FactoryBot.create(:list,
                                          name: "List 1",
                                          access_type: :shared) }
    let(:private_list) { FactoryBot.create(:list,
                                            name: "List 2",
                                            access_type: :personal) }

    let(:task) { FactoryBot.create(:list_task, list: public_list)}

    scenario 'list only public lists' do
      private_list

      visit lists_public_index_path

      expect(page).to have_content(public_list.name)
      expect(page).to_not have_content(private_list.name)
    end

    scenario 'show task in public list' do
      task

      visit lists_public_index_path

      expect(page).to have_content(task.name)
    end
  end
end
