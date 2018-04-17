module MenuHelper
  def main_menu(logged)
    if logged
      view_main_logged_in
    else
      view_main_logged_out
    end
  end

  private

  def view_main_logged_in
    "layouts/nav/logged_in"
  end

  def view_main_logged_out
    "layouts/nav/logged_out"
  end
end
