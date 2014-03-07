class Admin::Page < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  has_one :page_content, :dependent => :destroy, :autosave => true

  # attr_accessor :age   # make age writable and redable
  # attr_writer :secret #make secret only writable
  # attr_reader :employee_code # make it only readable
  attr_accessor :content

  def content= text
    begin
      if self.page_content.content.blank?
        self.page_content.content = text.gsub(/(\r\n){2,}/, "<br>\n").gsub(/\r\n/, "<br>\n").gsub(/(<br>{2,})/, "<br>\n")
      else
        self.page_content.content = text
      end
    rescue
      self.page_content.content = text
    end
  end

  def content
    self.page_content.content
  end

  acts_as_taggable

  validates :channel, :title, :short_title, presence: true
  validates :short_title, format: { with: /\A[a-zA-Z0-9-]+\z/,
    message: "名称简写只能包括字母数字和横线" }

  #cache
  after_save :expire_cache, :increase_page_count
  def increase_page_count
    Admin::Keystore.increment_value_for('admin_page_count')
  end
  def expire_cache
    logger.info "page #{self.id} saved!"
    cache_paths = [] 
    cache_paths << File.join(Rails.root, 'public', 'page_cache', 'index.html')
    cache_paths << File.join(Rails.root, 'public', 'page_cache', self.channel.short_title, self.id.to_s + '.html')
    cache_paths << File.join(Rails.root, 'public', 'page_cache', self.channel.id.to_s, self.id.to_s + '.html')
    cache_paths.each do |path|
      if File.exist?(path)
        FileUtils.rm_rf path
        logger.info "cache expire page: #{path}, #{!File.exist?(path)}"
      end
    end
  end

  def short_description(count = 50)
    self.description.to_s.truncate(count)
  end
  
  def format_date
    self.updated_at.strftime("%Y-%m-%d") unless self.updated_at.nil?
  end

  def thumb_image_path
    self.image_path.sub(/content/, 'thumb')
  end

  #最近新闻
  #typo = ['article', 'image', 'product']
  #channel =[ channel.short_title, ]
  #eg: Admin::Page.recent(12, :typo => 'product',  :rand => true)
  def self.recent(count = 10, options = {})
    options = {typo: 'all'}.merge(options)
    pages = options[:rand] ? Admin::Page.order(" rand() ") : Admin::Page.order("updated_at DESC")
    pages = pages.select{|p| p.channel.typo == options[:typo]} unless options[:typo] == 'all'
    pages = pages.select{|p| p.channel.short_title == options[:channel]}  unless options[:channel].nil?
    pages = pages.select{|p| p.properties == options[:properties]} unless options[:properties].nil?
    pages[0...count]
  end
  #搜索
  def self.search(search)
    if search
      puts ".................................................#{search}"
      where('title LIKE ?', "%#{search}%")
    else
      all
    end
  end

end
