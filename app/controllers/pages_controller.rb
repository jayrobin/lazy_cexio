class PagesController < ApplicationController
  def home
  	if user_signed_in?
  		@orders = current_user.orders.last(10)
  	end
  end
end
