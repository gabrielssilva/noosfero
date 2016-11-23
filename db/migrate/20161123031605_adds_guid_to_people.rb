class AddsGuidToPeople < ActiveRecord::Migration
  def up
    add_column :profiles, :guid, :string
  end

  def down
    remove_column :profiles, :guid
  end
end
