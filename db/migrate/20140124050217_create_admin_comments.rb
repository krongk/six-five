#encoding: utf-8
class CreateAdminComments < ActiveRecord::Migration
  def change
    create_table :admin_comments do |t|
      t.string :name
      t.string :mobile_phone
      t.string :tel_phone
      t.string :email
      t.string :qq
      t.string :address
      t.string :gender
      t.date :birth
      t.string :hobby
      t.text :content
      t.text :content2
      t.text :content3
      t.string :status
      t.timestamps
    end
  end
end
