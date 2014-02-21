#require 'reinvest'

desc "This task is called by the Heroku scheduler add-on"
task :reinvest => :environment do
	require "#{Rails.root}/lib/cexio/reinvest"

	User.find_all_reinvestors.each do |user|
		username = user.username
		key = user.key
		secret = user.secret

	  Reinvest.connectAPIWithVars user.username, user.key, user.secret
		Reinvest.buy "NMC" if user.reinvest_nmc
		Reinvest.buy "BTC" if user.reinvest_btc
	end
end