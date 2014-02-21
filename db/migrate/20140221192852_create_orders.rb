class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :currency
      t.decimal :unit_price
      t.decimal :volume
      t.decimal :total_price

      t.timestamps
    end
  end
end
