# -*- encoding : utf-8 -*-
require "openssl"
require "net/http"
require "net/https"
require "uri"
require "json"
require "addressable/uri"

module CEX

class API
  attr_accessor :api_key, :api_secret, :username, :nonce_v

  def initialize(username, api_key, api_secret)
    self.username = username
    self.api_key = api_key
    self.api_secret = api_secret
  end

  def api_call(method, param = {}, priv = false, couple = '')
    url = 'https://cex.io/api/'+method+'/'
    url = url + couple + '/' if couple != ''
    if priv
      self.nonce
      param.merge!(:key => self.api_key, :signature => self.signature.to_s, :nonce => self.nonce_v)
    end
    answer = self.post(url, param)
    JSON.parse(answer)
    # API down for maintenance
  rescue JSON::ParserError
    "API unavailable"
  end

  def ticker(couple = 'GHS/BTC')
    self.api_call('ticker', {}, false, couple)
  end

  def order_book(couple = 'GHS/BTC')
    self.api_call('order_book', {}, false, couple)
  end

  def trade_history(since = 1, couple = 'GHS/BTC')
    self.api_call('trade_history', {:since => since.to_s}, false, couple)
  end

  def balance
    self.api_call('balance', {}, true)
  end

  def open_orders(couple = 'GHS/BTC')
    self.api_call('open_orders', {}, true, couple)
  end

  def cancel_order(order_id)
    self.api_call('cancel_order', {:id => order_id.to_s}, true)
  end

  def place_order(ptype = 'buy', amount = 1, price =1, couple = 'GHS/BTC')
    self.api_call('place_order', {:type => ptype, :amount => amount.to_s, :price => price.to_s}, true, couple)
  end



  def nonce
    # fixed nonce to be based on millisecond rather than second timestamp
    self.nonce_v = (Time.now.to_f * 1000000).to_i.to_s
  end

  def signature
    str = self.nonce_v + self.username + self.api_key

    # replaced OpenSSL::Digest::Digest.new with OpenSSL::Digest.new
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), self.api_secret, str)
  end

  def post(url, param)
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    params = Addressable::URI.new
    params.query_values = param

    begin
      https.post(uri.path, params.query).body
    rescue => error
      "<html/>"
    end
  end
end
end