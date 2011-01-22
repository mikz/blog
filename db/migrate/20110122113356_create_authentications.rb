class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.string :provider, :null => false
      t.string :uid, :null => false
      t.integer :user_id, :null => false
      
      
      t.timestamps
    end
    
    add_foreign_key :authentications, :users, :dependent => :cascade
    #add_index :authentications, [:provider, :user_id], :unique => true
    add_index :authentications, [:provider, :uid], :unique => true
  end

  def self.down
    drop_table :authentications
  end
end
