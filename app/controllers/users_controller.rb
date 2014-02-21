class UsersController < ApplicationController
  def toggle_reinvest_btc
  	if user_signed_in?
  		current_user.toggle(:reinvest_btc)
  		current_user.save
    end
    redirect_to(root_url)
  end

  def toggle_reinvest_nmc
  	if user_signed_in?
  		current_user.toggle(:reinvest_nmc)
  		current_user.save
    end
    redirect_to(root_url)
  end
end