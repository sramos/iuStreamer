class CreateChannels < ActiveRecord::Migration  
  def self.up  
    create_table :channels do |t|  
      t.string :name  
      t.string :description
      t.string :email  
      t.string :crypted_password  
      t.string :password_salt  
      t.string :persistence_token  
      t.string :stream_token
      t.integer :views, :default => 0
      t.timestamps  
    end  
  end   

  def self.down  
    drop_table :channels  
  end  
end
