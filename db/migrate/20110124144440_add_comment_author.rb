class AddCommentAuthor < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.remove :author, :author_email, :author_url
      t.string :author_name
      t.belongs_to :author
      t.foreign_key :users, :column => :author_id, :dependent => :cascade
    end
  end

  def self.down
    change_table :comments do |t|
      t.string :author, :author_email, :author_url
      t.remove :author_id, :author_name
    end
  end
end
