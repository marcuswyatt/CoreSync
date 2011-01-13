class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title
      t.text :body
      t.integer :read_count
      t.float :lat
      t.decimal :lng
      t.timestamp :published_at
      t.time :last_read
      t.date :actioned_at
      t.boolean :published
      
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      
      t.references :worker

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
