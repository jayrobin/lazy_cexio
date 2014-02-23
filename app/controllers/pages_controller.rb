class PagesController < ApplicationController
  def home
  	if user_signed_in?
  		@orders = current_user.orders.order("id DESC").paginate(page: params[:page], per_page: 10)
  	end
  end
end
