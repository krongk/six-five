class Admin::Channel < ActiveRecord::Base
  belongs_to :user
  has_many :pages, dependent: :destroy
  has_many :children, class_name: "Admin::Channel",
                          foreign_key: "parent_id",
                          dependent: :destroy
  belongs_to :parent, class_name: "Admin::Channel"

  TYPOS = %w[article image product]
  
  acts_as_taggable

  validates :typo, :title, :short_title, :tmp_index, :tmp_detail, presence: true
  validates :short_title, format: { with: /\A[a-zA-Z0-9-]+\z/,
    message: "名称简写只能包括字母数字和横线" }

  #cache
  after_save :expire_cache
  def expire_cache
    logger.info "Channel #{self.id} saved!"
    cache_paths = [] 
    cache_paths << File.join(Rails.root, 'public', 'page_cache', 'index.html')
    cache_paths << File.join(Rails.root, 'public', 'page_cache', self.short_title + '.html')
    cache_paths << File.join(Rails.root, 'public', 'page_cache', self.id.to_s + '.html')
    cache_paths.each do |path|
      if File.exist?(path)
        FileUtils.rm_rf path 
        logger.info "cache expire page: #{path}, #{!File.exist?(path)}"
      end
    end
  end

end
