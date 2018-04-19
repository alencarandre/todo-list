class Lists::MineController < ApplicationController
  before_action :authenticate_user!

  def index
    @lists = List.by_user(current_user).all
  end

end
