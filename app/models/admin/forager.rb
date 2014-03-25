class Admin::Forager < ActiveRecord::Base
  scope :source, -> { group('source') }

  scope :unmigrated, -> { where(is_migrated: 'n') }
  scope :fmigrated, -> { where(is_migrated: 'f') }

  validates :content, :title, presence: true

end
