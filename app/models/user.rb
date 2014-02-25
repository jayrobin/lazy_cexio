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
  	return  !username.blank? && !key.blank? && !secret.blank?
  end

  def get_volume_traded_today
  	get_volume_traded_since 1.day.ago
  end

  def get_volume_traded_week
  	get_volume_traded_since 1.week.ago
  end

  def get_volume_traded_month
  	get_volume_traded_since 1.month.ago
  end

  def get_volume_traded_all
  	get_volume_traded_since created_at
  end

  def get_volume_traded_since date
  	orders.where("created_at > ?", date).sum(:volume)
  end
end
