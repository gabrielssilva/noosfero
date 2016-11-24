class AddsGuidToScraps < ActiveRecord::Migration
  def up
    add_column :scraps, :guid, :string
  end

  def down
    remove_column :scraps, :guid
  end
end
