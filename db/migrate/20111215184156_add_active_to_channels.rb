class AddActiveToChannels < ActiveRecord::Migration
  def self.up
    add_column :channels, :active, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :channels, :active
  end
end
