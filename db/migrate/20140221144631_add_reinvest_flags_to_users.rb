class AddReinvestFlagsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :reinvest_btc, :boolean, default: false
  	add_column :users, :reinvest_nmc, :boolean, default: false
  end
end
