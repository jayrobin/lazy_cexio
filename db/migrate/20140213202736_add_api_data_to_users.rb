class AddApiDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :key, :string
    add_column :users, :secret, :string
  end
end
