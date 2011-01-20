class CreateFormats < ActiveRecord::Migration
  def self.up
    create_table :formats do |t|
      t.string :class_name, :name, :method
      t.boolean :disabled, :null => false, :default => false
      t.timestamps
    end
    add_column :pages, :format_id, :integer
    add_column :posts, :format_id, :integer
  end

  def self.down
    drop_table :formats
    remove_column :pages, :format_id
    remove_column :posts, :format_id
  end
end
