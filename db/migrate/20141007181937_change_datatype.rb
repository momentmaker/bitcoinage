class ChangeDatatype < ActiveRecord::Migration
  def up
    change_column :transactions, :satoshi, :integer, null: false, limit: 8
  end

  def down
    change_column :transactions, :satoshi, :integer, null: false
  end
end
