class PagesController < ApplicationController
  def home
  	redirect_to setup_path if user_signed_in? && !current_user.api_setup_complete?

  	if user_signed_in?
  		@orders = current_user.orders.order("id DESC").paginate(page: params[:page], per_page: 10)
  		
  		@day_volume = "%.8f" % current_user.get_volume_traded_today
  		@week_volume = "%.8f" % current_user.get_volume_traded_week
  		@month_volume = "%.8f" % current_user.get_volume_traded_month
  		@all_volume = "%.8f" % current_user.get_volume_traded_all
  	end
  end

  def setup
  	redirect_to root_path unless user_signed_in?
  	@user = current_user
  end

  def update_setup
  	current_user.username = params[:user][:username]
  	current_user.key = params[:user][:key]
  	current_user.secret = params[:user][:secret] unless params[:user][:secret] == ""
  	current_user.save

  	redirect_to root_path
  end
end
