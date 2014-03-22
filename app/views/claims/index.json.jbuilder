json.array!(@claims) do |claim|
  json.extract! claim, :id, :admin_page_id, :email, :phone, :message, :is_processed
  json.url claim_url(claim, format: :json)
end
