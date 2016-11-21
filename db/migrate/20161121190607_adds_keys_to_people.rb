class AddsKeysToPeople < ActiveRecord::Migration
  def up
    add_column :profiles, :private_key, :text
    add_column :profiles, :public_key, :text
  end

  def down
    remove_column :profiles, :private_key
    remove_column :profiles, :public_key
  end
end
