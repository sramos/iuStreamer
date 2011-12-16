class AddAdminToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :admin, :boolean, :default => false, :null => false
  end

  def self.down
    drop_column :channels, :admin
  end
end
