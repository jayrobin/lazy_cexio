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
			volume = (((balance.to_f / price) * 100000000).floor.to_f / 100000000) * 0.997


			return unless volume.to_f > 0

			trade = @api.place_order("buy", "%.8f" % volume, "%.8f" % price, "GHS/#{currency}")

			if trade["id"]
				order = Hash.new
				order[:currency] = currency
				order[:unit_price] = price
				order[:volume] = volume
				order[:total_price] = balance

				return order
			else
				# insufficient funds
				nil
			end
		end
	end
end
