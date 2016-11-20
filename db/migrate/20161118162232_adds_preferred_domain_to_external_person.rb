class AddsPreferredDomainToExternalPerson < ActiveRecord::Migration
  def up
    add_column :external_people, :preferred_domain_id, :integer
  end

  def down
    remove_column :external_people, :preferred_domain_id
  end
end
