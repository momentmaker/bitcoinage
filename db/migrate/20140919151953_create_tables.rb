class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :username, null: false
      t.string :name, null: false
      t.string :image
      t.string :url, null: false

      t.timestamps
    end

    create_table :transactions do |t|
      t.integer :quantity, null: false
      t.integer :price, null: false
      t.integer :fees, null: false
      t.date :date, null: false
      t.string :wallet
      t.string :hash
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
