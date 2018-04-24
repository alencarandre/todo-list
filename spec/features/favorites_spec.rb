require 'rails_helper'
require 'capybara_support'

feature 'Favorite Lists' do
  include CapybaraSupport

  context 'when user is logged' do
    before(:each) { login(FactoryBot.create(:user)) }

    scenario 'show favorite lists to logged user' do
      list_favorite = FactoryBot.create(:list_favorite, user: current_user)
      another_list_favorite = FactoryBot.create(:list_favorite)

      visit lists_favorites_path

      expect(page).to have_content(list_favorite.list.name)
      expect(page).to_not have_content(another_list_favorite.list.name)
    end

    scenario 'mark list as favorite to logged user', js: :true do
      list = FactoryBot.create(:list)

      visit lists_public_index_path

      href = list_mark_as_favorite_path(list)
      find("a[href=\"#{href}\"]").click

      visit lists_favorites_path

      expect(page).to have_content(list.name)
    end

    scenario 'remove list from favorite to logged user', js: :true do
      list = FactoryBot.create(:list)
      list.favor!(current_user)

      visit lists_public_index_path

      href = list_mark_as_unfavorite_path(list)
      find("a[href=\"#{href}\"]").click

      visit lists_favorites_path

      expect(page).to_not have_content(list.name)
    end
  end

end
