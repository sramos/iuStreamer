class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.integer :channel_id
      t.string :title
      t.string :filename
      t.boolean :live
      t.integer :viewers, :default => 0
      t.integer :max_viewers, :default => 0
      t.integer :views, :default => 0
      t.boolean :public, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
