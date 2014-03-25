class Admin::Keystore < ActiveRecord::Base
  validates :key, :value, presence: true
  after_save :clean_cache

  def clean_cache
    Rails.cache.delete('templete')
    Rails.cache.delete('site_name')
    Rails.cache.delete('temp_list')
  end

  def self.get(key)
    self.find_by_key(key)
  end

  def self.put(key, value)
    ks = self.find_or_create_by_key(key)
    #ks.value = ks.value + value
    ks.value = value
    ks.save!
    true
  end

  def self.increment_value_for(key, amount = 1)
    self.incremented_value_for(key, amount)
  end

  def self.decrement_value_for(key, amount = -1)
    self.incremented_value_for(key, amount)
  end


  def self.incremented_value_for(key, amount = 1)
    new_value = nil

    Admin::Keystore.transaction do
      ks = self.find_or_create_by_key(key)
      ks.value = ks.value.to_i + amount
      ks.save!
      new_value = self.value_for(key)
    end

    return new_value
  end

  

  def self.value_for(key)
    self.get(key).try(:value)
  end
end


#useage:
#    Keystore.increment_value_for("user:#{self.user_id}:comments_posted")

