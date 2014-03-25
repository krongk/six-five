class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.references :admin_page, index: true
      t.string :email
      t.string :phone
      t.text :message
      t.string :is_processed, default: 'n'

      t.timestamps
    end
  end
end
