require 'rails_helper'

feature 'Registration' do

  context 'create account' do
    it 'registry account with name' do
      name = Faker::Name.name
      email = Faker::Internet.email

      expect(User.where(name: name).first).to be_blank

      visit '/users/sign_up'
      fill_in 'user_name', with: name
      fill_in 'user_email', with: email
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'

      within("div.actions") do
        click_button 'Sign up'
      end

      user = User.where(name: name).first

      expect(user).to be_present
      expect(user.name).to eq(name)
      expect(user.email).to eq(email)
    end
  end
end
