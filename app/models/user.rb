class User < ActiveRecord::Base
	attr_encrypted :secret, key: ENV["SECRET_KEY"], :unless => Rails.env.development?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders, dependent: :destroy

  def self.find_all_reinvestors
  	User.where("reinvest_btc = ? OR reinvest_nmc = ?", true, true)
  end
end
