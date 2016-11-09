class AddsTypeToExternalPerson < ActiveRecord::Migration
  def up
    unless column_exists? :external_people, :type
      add_column :external_people, :type, :string, default: 'ExternalPerson'
    end
  end

  def down
    remove_column :external_people, :type
  end
end
