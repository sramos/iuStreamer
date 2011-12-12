class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.integer :channel_id
      t.string :title
      t.string :filename
      t.boolean :live
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
