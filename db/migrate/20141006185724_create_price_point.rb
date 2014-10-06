class CreatePricePoint < ActiveRecord::Migration
  def change
    create_table :price_points do |t|
      t.integer :date, limit: 8, null: false
      t.float :price, null: false
    end
  end
end
