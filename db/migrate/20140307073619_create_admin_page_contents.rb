class CreateAdminPageContents < ActiveRecord::Migration
  def change
    create_table :admin_page_contents do |t|
      t.references :page, index: true
      t.text :content

      t.timestamps
    end
  end
end
