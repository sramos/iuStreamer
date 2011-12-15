class AddChannelsPasswordResetFields < ActiveRecord::Migration

  def self.up  
    add_column :channels, :perishable_token, :string, :default => "", :null => false  
  
    add_index :channels, :perishable_token  
    add_index :channels, :email  
    add_index :channels, :name
  end  
  
  def self.down  
    remove_column :channels, :perishable_token  
  end  

end
