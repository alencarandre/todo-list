module DeviseSupport
  def login(user)
    @current_user = user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @current_user
  end

  def current_user
    @current_user
  end
end
