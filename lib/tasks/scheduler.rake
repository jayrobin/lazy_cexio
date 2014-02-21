#require 'reinvest'

desc "This task is called by the Heroku scheduler add-on"
task :reinvest => :environment do
	require "#{Rails.root}/lib/cexio/reinvest"

	User.find_all_reinvestors.each do |user|
		username = user.username
		key = user.key
		secret = user.secret

	  Reinvest.connectAPIWithVars user.username, user.key, user.secret
		buy user, "NMC" if user.reinvest_nmc
		buy user, "BTC" if user.reinvest_btc
	end
end

def buy user, currency
	order = Reinvest.buy currency
	user.orders.build(order) unless order.nil?
	user.save
end