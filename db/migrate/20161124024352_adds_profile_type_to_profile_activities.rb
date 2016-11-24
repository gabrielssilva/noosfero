class AddsProfileTypeToProfileActivities < ActiveRecord::Migration
  def up
    add_column :profile_activities, :profile_type, :string, default: 'Profile'
  end

  def down
    remove_column :profile_activities, :profile_type
  end
end
