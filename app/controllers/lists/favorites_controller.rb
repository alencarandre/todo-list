class Lists::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @lists = current_user.favorites.order_created_at_desc.all
  end

end
