class CreateAdminKeystores < ActiveRecord::Migration
  def change
    create_table :admin_keystores, :options=>'charset=utf8' do |t|
      t.string :key
      t.string :value
      t.string :description

      t.timestamps
    end
    add_index :admin_keystores, :key
  end
end
