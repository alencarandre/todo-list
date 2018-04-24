class Lists::PublicController < ApplicationController
  before_action :authenticate_user!

  def index
    @lists = List.shared_lists
                 .order_created_at_desc
  end

end
