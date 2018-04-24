class HomeController < ApplicationController

  def index
    redirect_to lists_mine_index_path if user_signed_in?
  end

end
