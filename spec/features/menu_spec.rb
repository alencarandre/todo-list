require 'rails_helper'

feature "menu" do
  context 'when user not logged' do
    it 'show only sign in and sign up options' do
      visit '/'
      within("#navbarMenu ul") do
        expect(page).to have_selector('li', count: 2)
        expect(page).to have_content(I18n.t("sign_in"))
        expect(page).to have_content(I18n.t("sign_up"))
      end
    end
  end

  context 'when user is logged' do
    let(:user) { FactoryBot.create(:user, password: '123456', password_confirmation: '123456')}
    before(:each) do
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '123456'

      within("div.actions") do
        click_button I18n.t('sign_in')
      end
    end

    it 'not show sign in and sign up options' do
      visit '/'
      within("#navbarMenu ul") do
        expect(page).to_not have_content(I18n.t("sign_in"))
        expect(page).to_not have_content(I18n.t("sign_up"))
      end
    end

    it 'has sign out option' do
      visit '/'
      within("#navbarMenu ul") do
        expect(page).to have_content(I18n.t("sign_out"))
      end
    end
  end
end
