module CapybaraSupport
  def login(user)
    @current_user = user

    visit new_user_session_path
    fill_in 'user_email', with: @current_user.email
    fill_in 'user_password', with: '123456'

    within("div.actions") do
      click_button I18n.t('sign_in')
    end
  end

  def current_user
    @current_user
  end
end
