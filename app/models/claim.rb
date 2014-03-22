class Claim < ActiveRecord::Base
  belongs_to :admin_page

  validates :email, :message, presence: true
  #validates :phone, length: { is: 11 }
  #validates :phone, format: { with: /\A1(3|5|8|9)[0-9]{9}\z/, message: "请输入正确的手机号码" }
end
