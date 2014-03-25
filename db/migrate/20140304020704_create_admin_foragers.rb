class CreateAdminForagers < ActiveRecord::Migration
  def change
    create_table :admin_foragers do |t|
      t.string :is_migrated, default: 'n'
      t.string :is_processed, default: 'n'
      t.string :source, default: 'user'
      t.string :author
      t.string :title
      t.text :content
      t.string :tag
      t.string :channel
      t.integer :rant_count
      t.date :post_date
      t.string :name
      t.string :email
      t.string :message
      t.string :source_url
      t.timestamps
    end
  end
end
