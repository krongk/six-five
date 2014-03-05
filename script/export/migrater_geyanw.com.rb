#encoding: utf-8
# == Usage
# > ruby migrate_data.rb 
# this script use to migrate local data to common.
# steps:
# 1. check local db
#    format contenet to huxun/wenba_post_format
# =>   add column is_migrated to xx_post_format
# 2. run migrater.rb 

  # SELECT * from forager_posts where source = 'geyanw.com' 
  # and page_html not REGEXP '选自：www.geyanw.com  人生格言网' 
  # and page_html not REGEXP '摘自：www.geyanw.com 格言网'
  # and page_html not REGEXP '读书名言网（www.geyanw.com）提供'
  # and page_html not REGEXP '选自：名言警句（www.geyanw.com）'
  # and page_html REGEXP 'www.geyanw.com'
  # order by id desc LIMIT 300;

$:.unshift(File.dirname(__FILE__))
require "rubygems"
require "local_tables"
require "pp"
require 'chinese_pinyin'
require 'iconv'

class Migrator
  def initialize
    @source = 'geyanw.com'
  end
  
  def migrate(post, channel)
    begin
      page = AdminPage.find_or_initialize_by(title: post.title, channel_id: channel.id)
      page.content = post.page_html
      page.keywords = post.tag
      page.short_title = Pinyin.t(page.title).gsub(/[^a-zA-Z0-9-]+/, '-')
      page.user_id = 1
      page.save!

      post.is_migrated = 'y'
      post.save!
      puts page.id
    rescue => ex
      puts ex.message
      post.is_migrated = 'f'
      post.save!
    end
  end

  def format(post)
    page_html = post.content.gsub(/(选自.*\n)/, '')
    page_html = page_html.gsub(/(摘自.*\n)/, '')
    page_html = page_html.gsub(/(搞自：.*\n)/, '')
    page_html = page_html.gsub(/(读书名言网.*\n)/, '')
    page_html = page_html.gsub(/(名言网.*\n)/, '')
    page_html = page_html.gsub(/(格言网.*\n)/, '')
    page_html = page_html.gsub(/(www.geyanw.com  收集.*\n)/, '')
    page_html = page_html.gsub(/(www.geyanw.com.*\n)/, '')
    post.page_html = page_html.gsub(/(\r\n){2,}/, "<br>\n").gsub(/\r\n/, "<br>\n").gsub(/(<br>{2,})/, "<br>\n")
    post.is_processed = 'y'
    post.save!
  end

  def run
    puts 'start post...'
    ForagerPost.where(source: @source, is_processed: 'n').find_each do |post|
      format(post)
      puts post.id
    end

    puts 'start migrate...'
    index = 0
    ForagerPost.where(source: @source, is_migrated: 'n').find_each do |post|
      channel = AdminChannel.where(title: '微语录').first
      migrate(post, channel)
      puts post.id
      #index += 1
      #break if index > 6
    end
    puts 'done...'
  end
end

if __FILE__ == $0
  Migrator.new.run
end