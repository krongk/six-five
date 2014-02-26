json.array!(@comments) do |comment|
  json.extract! comment, :id, :name, :mobile_phone, :tel_phone, :email, :qq, :address, :gender, :birth, :hobby, :content, :content2, :content3, :status
  json.url comment_url(comment, format: :json)
end
