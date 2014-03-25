#encoding: utf-8
# == Usage
# > ruby migrate_data.rb 
# this script use to migrate local data to common.
# steps:
# 1. check local db
#    format contenet to huxun/wenba_post_format
# =>   add column is_exported to xx_post_format
# 2. run migrater.rb 

$:.unshift(File.dirname(__FILE__))
require "rubygems"
require "local_tables"
require "pp"
require 'chinese_pinyin'
require 'nokogiri'
require 'mechanize'
require 'uri'
require 'open-uri'

class Forager
  def initialize
    @source = 'geyanw.com'

    @list_arr = []
    (1..4).each do |i|
      @list_arr << ["人生格言", "http://www.geyanw.com/html/renshenggeyan/list_4_#{i}.html"]
    end
    (1..3).each do |i|
      @list_arr << ["励志名言", "http://www.geyanw.com/html/jingdianduanju/list_9_#{i}.html"]
    end
    (1..5).each do |i|
      @list_arr << ["名言警句", "http://www.geyanw.com/html/mingyanjingju/list_6_#{i}.html"]
    end
    (1..4).each do |i|
      @list_arr << ["名人名言", "http://www.geyanw.com/html/mingrenmingyan/list_1_#{i}.html"]
    end
    (1..5).each do |i|
      @list_arr << ["读书名言", "http://www.geyanw.com/html/dushumingyan/list_5_#{i}.html"]
    end
    (1..44).each do |i|
      @list_arr << ["经典名言", "http://www.geyanw.com/html/jingdianmingyan/list_2_#{i}.html"]
    end
    (1..4).each do |i|
      @list_arr << ["爱情名言", "http://www.geyanw.com/html/aiqingmingyan/list_3_#{i}.html"]
    end
    (1..2).each do |i|
      @list_arr << ["爱情名言", "http://www.geyanw.com/html/aiqinggeyan/list_7_#{i}.html"]
    end
    (1..3).each do |i|
      @list_arr << ["英语名言", "http://www.geyanw.com/html/yingyumingyan/list_8_#{i}.html"]
    end
  end
  
  def init_run_keys
    puts "init"
    @list_arr.each do |list|
      tag = list[0]
      list_url = list[1]
      adoc = Nokogiri::HTML(open(list_url).read)
      adoc.at(".newlist").search("h2 a").each do |link|
        u = link.attributes['href'].value
        url = "http://www.geyanw.com" + u
        puts url
        ForagerRunKey.find_or_create_by(url: url, tag: tag)
      end
    end
  end

  def run
    init_run_keys
    forage_detail
  end
  def forage_detail
    puts "forage"
    ForagerRunKey.where(is_processed: 'n').find_each do |key|
      begin
        doc = Nokogiri::HTML(open(key.url).read)
        article = doc.at("div.viewbox")
        title = article.at("div.title h2").text
        #author = article.at(".article_author").text
        text = article.at(".content").text
        post = ForagerPost.find_or_initialize_by(url: key.url)
        post.content = text.strip
        post.source = @source
        post.title = title.strip
        post.tag = key.tag
        post.channel = '微语录'
        post.save!

        key.is_processed = 'y'
      rescue => ex
        puts ex.message
        key.is_processed = 'f'
      end
      key.save!
    end
  end

end

if __FILE__ == $0
  Forager.new.run
end