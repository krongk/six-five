json.array!(@admin_foragers) do |admin_forager|
  json.extract! admin_forager, :id, :is_migrated, :is_processed, :source, :author, :title, :content, :tag, :channel, :rant_count, :post_date
  json.url admin_forager_url(admin_forager, format: :json)
end
