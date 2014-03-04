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
  
  def run
    puts 'start post...'
    i = 0
    begin
      begin
        @list_arr.each do |list|
          tag = list[0]
          list_url = list[1]
          adoc = Nokogiri::HTML(open(list_url).read)
          adoc.at(".newlist").search("h2 a").each do |link|
            u = link.attributes['href'].value
            url = "http://www.geyanw.com" + u
            puts url

            doc = Nokogiri::HTML(open(url).read)
            article = doc.at("div.viewbox")
            title = article.at("div.title h2").text
            #author = article.at(".article_author").text
            text = article.at(".content").text
            post = ForagerPost.find_or_initialize_by(title: title.strip)
            post.content = text.strip
            post.source = @source
            post.url = url
            post.tag = tag
            post.channel = '微语录'
            post.save!
            
            sleep(2)
          end
        end
      rescue => ex
        puts ex.message
        retry
      end
    end until i > 1000000
  end
end

if __FILE__ == $0
  Forager.new.run
end