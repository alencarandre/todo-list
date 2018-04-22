class Lists::MineController < ApplicationController
  before_action :authenticate_user!

  def index
    @lists = List.order_created_at_desc.by_user(current_user).all
  end

end
