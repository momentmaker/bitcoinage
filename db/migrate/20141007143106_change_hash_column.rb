class ChangeHashColumn < ActiveRecord::Migration
  def change
    rename_column :transactions, :hash, :trans_hash
  end
end
