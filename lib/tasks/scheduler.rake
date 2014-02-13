#require 'reinvest'

desc "This task is called by the Heroku scheduler add-on"
task :reinvest => :environment do
	require "#{Rails.root}/lib/cexio/reinvest"

	User.all.each do |user|
		username = user.username
		key = user.key
		secret = user.secret

	  Reinvest.connectAPIWithVars user.username, user.key, user.secret
		Reinvest.buy "NMC"
		Reinvest.buy "BTC"
	end
end