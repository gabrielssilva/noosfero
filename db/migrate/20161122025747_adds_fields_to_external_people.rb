class AddsFieldsToExternalPeople < ActiveRecord::Migration
  def up
    add_column :external_profiles, :guid, :string
    add_column :external_profiles, :public_key, :text
  end

  def down
    remove_column :external_profiles, :guid
    remove_column :external_profiles, :public_key
  end
end
