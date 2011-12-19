class AddDurationToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :duration, :integer
  end

  def self.down
    remove_column :videos, :duration
  end
end
