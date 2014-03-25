#encoding: utf-8
# == Usage
# > ruby migrate_data.rb 
# this script use to migrate local data to common.
# steps:
# 1. check local db
#    format contenet to huxun/wenba_post_format
# =>   add column is_migrated to xx_post_format
# 2. run migrater.rb 

$:.unshift(File.dirname(__FILE__))
require "rubygems"
require "local_tables"
require "pp"
require 'chinese_pinyin'

class Migrator
  def initialize
    @source = 'duanwenxue.com'
  end
  
  def migrate(post)
    begin
      channel = AdminChannel.where(title: post.channel).first
      if channel.nil?
        post.is_migrated = 'bad channel'
      else
        page = AdminPage.find_or_initialize_by(title: post.title, author: post.author)
        page.content = post.content.gsub(/(\r\n){2,}/, "<br>\n").gsub(/\r\n/, "<br>\n").gsub(/\n/, "<br>\n")
        page.keywords = post.tag.strip
        page.short_title = Pinyin.t(page.title).gsub(/[^a-zA-Z0-9-]+/, '-')
        page.user_id = 1
        page.channel_id = channel.id
        page.save!
        puts page.id
        post.is_migrated = 'y'
      end
      post.save!
    rescue => ex
      puts ex.message
      post.is_migrated = 'f'
      post.save!
    end
  end

  def run
    puts 'start post...'
    ForagerPost.where(source: @source, is_processed: 'n').find_each do |post|
      page_html = post.content
      page_html = page_html.gsub(/(\r\n\s+.*\.\.\.\[阅读全文\])/, '')
      page_html = page_html.gsub(/(\r\n){2,}/, "<br>\n").gsub(/\r\n/, "<br>\n").gsub(/\n/, "<br>\n")
      page_html = page_html.gsub(/(\s+<br><br>\n\s+.*)$/, '')
      page_html = page_html.gsub(/(\s*<br><br>\n\s*.*..\[阅读全文\])$/, '')

      post.page_html = page_html
      puts post.id
      post.is_processed = 'y'
      post.save!
      #break
    end

    puts 'start post...'
    ForagerPost.where(source: @source, is_migrated: 'n').find_each do |post|
      migrate(post)
      puts post.id
      #break
    end
    puts 'done...'
  end
end

if __FILE__ == $0
  Migrator.new.run
end