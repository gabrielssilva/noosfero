class AddsSenderAndReceiverTypesToScraps < ActiveRecord::Migration
  def up
    add_column :scraps, :sender_type, :string, default: 'Profile'
    add_column :scraps, :receiver_type, :string, default: 'Profile'
  end

  def down
    remove_column :scraps, :sender_type
    remove_column :scraps, :receiver_type
  end
end
