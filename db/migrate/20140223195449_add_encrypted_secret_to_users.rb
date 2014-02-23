class AddEncryptedSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_secret, :string
  end
end
