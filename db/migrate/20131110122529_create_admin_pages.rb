class CreateAdminPages < ActiveRecord::Migration
  def change
    create_table :admin_pages, :options=>'charset=utf8' do |t|
      t.references :user, index: true
      t.references :channel, index: true
      t.string :title
      t.string :short_title
      t.string :properties
      t.string :keywords
      t.string :description
      t.string :image_path
      t.text :content

      t.timestamps
    end
    add_index :admin_pages, :short_title  
  end
end
