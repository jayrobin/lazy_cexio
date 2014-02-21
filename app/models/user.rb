class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.find_all_reinvestors
  	User.where("reinvest_btc = ? OR reinvest_nmc = ?", true, true)
  end
end
