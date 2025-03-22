class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.integer :quantity, null: false, default: 0
      t.bigint :total_price, null: false, precision: 10, scale: 2
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :cart, null: false, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
