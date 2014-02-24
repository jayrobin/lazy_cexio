class User < ActiveRecord::Base
	attr_encrypted :secret, key: Rails.env.development? ? 'SECRET_KEY' : ENV['SECRET_KEY']

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders, dependent: :destroy

  def self.find_all_reinvestors
  	User.where("reinvest_btc = ? OR reinvest_nmc = ?", true, true)
  end

  def api_setup_complete?
  	return  username != "" && key != "" && secret != ""
  end
end
