#!/usr/bin/env ruby
require_relative 'cexio'
require 'json'

class Reinvest
	class << self
		attr_reader :api
	end

	def self.connectAPIWithVars username, key, secret
		@api = CEX::API.new(username, key, secret)
	end

	def self.buy currency
		response = @api.balance
		balance = response[currency] ? response[currency]["available"] : 0
		if balance.to_f > 0.00000001
			price = @api.ticker("GHS/#{currency}")["bid"].to_f
			volume = "%.8f" % (((balance.to_f / price) * 100000000).floor.to_f / 100000000)

			return unless volume.to_f > 0

			order = @api.place_order("buy", volume, "%.8f" % price, "GHS/#{currency}")

			if order["id"]
				puts "Order placed: BUY #{volume} GHS at #{price}, cost #{balance} #{currency} (id: #{order["id"]})"
			else
				# insufficient funds
				puts "Order not placed: #{order["error"]} (BUY #{volume} GHS at #{price}, cost #{balance} #{currency})"
			end
		end
	end
end