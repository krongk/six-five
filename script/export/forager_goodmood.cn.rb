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
    @source = 'goodmood.cn'

    @list_arr = []
    (1..3538).each do |i|
      @list_arr << ["微写作", "感悟生活", "http://prose.goodmood.cn/class/10/#{i}"]
    end
    (1..1735).each do |i|
      @list_arr << ["微情书", "爱情滋味", "http://prose.goodmood.cn/class/11/#{i}"]
    end
    (1..744).each do |i|
      @list_arr << ["微写作", "挚爱亲情", "http://prose.goodmood.cn/class/12/#{i}"]
    end
    (1..301).each do |i|
      @list_arr << ["微写作", "友情天地", "http://prose.goodmood.cn/class/13/#{i}"]
    end
    (1..271).each do |i|
      @list_arr << ["微日记", "青春校园", "http://prose.goodmood.cn/class/14/#{i}"]
    end
    (1..162).each do |i|
      @list_arr << ["微写作", "婚姻物语", "http://prose.goodmood.cn/class/15/#{i}"]
    end

    (1..372).each do |i|
      @list_arr << ["微观点", "乱弹八卦", "http://essay.goodmood.cn/class/16/#{i}"]
    end
    (1..626).each do |i|
      @list_arr << ["微观点", "百家杂谈", "http://essay.goodmood.cn/class/17/#{i}"]
    end
    (1..251).each do |i|
      @list_arr << ["微观点", "处事之道", "http://essay.goodmood.cn/class/18/#{i}"]
    end
    (1..76).each do |i|
      @list_arr << ["微观点", "局外观史", "http://essay.goodmood.cn/class/19/#{i}"]
    end
    (1..248).each do |i|
      @list_arr << ["微观点", "针砭时弊", "http://essay.goodmood.cn/class/20/#{i}"]
    end
    (1..151).each do |i|
      @list_arr << ["微观点", "影视书评", "http://essay.goodmood.cn/class/21/#{i}"]
    end

    (1..11075).each do |i|
      @list_arr << ["微诗歌", "现代诗歌", "http://poetry.goodmood.cn/PoemList.aspx?classid=0&page=#{i}"]
    end
    (1..149720).each do |i|
      @list_arr << ["微诗歌", "古词风韵", "http://poetry.goodmood.cn/PoemList.aspx?classid=1&page=#{i}"]
    end
    (1..229).each do |i|
      @list_arr << ["微诗歌", "天涯行歌", "http://poetry.goodmood.cn/PoemList.aspx?classid=2&page=#{i}"]
    end
    
    (1..60).each do |i|
      @list_arr << ["微诗歌", "谈诗论道", "http://poetry.goodmood.cn/CommentList.aspx?page=#{i}"]
    end
    (1..1835).each do |i|
      @list_arr << ["微诗歌", "谈诗论道", "http://poetry.goodmood.cn/Good.aspx?page=#{i}"]
    end
    (1..1741 ).each do |i|
      @list_arr << ["微诗歌", "参赛诗歌", "http://poetry.goodmood.cn/MatchList.aspx?page=#{i}"]
    end
    (1..1741 ).each do |i|
      @list_arr << ["微诗歌", "参赛诗歌", "http://poetry.goodmood.cn/MatchList.aspx?page=#{i}"]
    end
  end

  def run
    init_run_keys
    init_forager_run_keys
    forage_detail
  end
  
  def init_run_keys
    puts 'done init run keys'
    @list_arr.each do |list|
      r = RunKey.find_or_initialize_by(url: list[-1])
      r.tag = list[1]
      r.channel = list[0]
      r.save!
    end
  end

  def init_forager_run_keys
    puts "init forager run key"
    RunKey.where(is_processed: 'n').find_each do |key|
      begin
        flag = 'f'
        tag = key.tag
        channel = key.channel
        adoc = Nokogiri::HTML(open(key.url).read)
        #http://essay.goodmood.cn/class/21
        if adoc.at(".listbody")
          adoc.at(".listbody").search("li").each do |item|
            u = item.at(".name").at("a").attributes['href'].value
            url = key.url.gsub(/goodmood.cn(.*)/, '') + 'goodmood.cn' + u
            author = item.at(".user").at("a").text
            forager = ForagerRunKey.find_or_initialize_by(url: url)
            forager.author = author.strip
            forager.tag = tag
            forager.channel = channel
            forager.save!
          end
          flag = 'y-1'
        end
        #http://poetry.goodmood.cn/MatchList.aspx
        if adoc.at(".left_b")
          adoc.at(".left_b").search(".left_be").each do |item|
            u = item.at("a").attributes['href'].value
            url = key.url.gsub(/goodmood.cn(.*)/, '') + 'goodmood.cn' + u
            author = item.at(".l_2").at("a").text
            forager = ForagerRunKey.find_or_initialize_by(url: url)
            forager.author = author.strip
            forager.tag = tag
            forager.channel = channel
            forager.save!
          end
          flag = 'y-2'
        end
        #http://poetry.goodmood.cn/PoemList.aspx
        if adoc.at(".m_left_r")
          adoc.at(".m_left_r").search(".m_left_tita").each do |item|
            url = item.at("bt_a").at("a").attributes['href'].value
            author = item.at(".zz_a").at("a").text
            forager = ForagerRunKey.find_or_initialize_by(url: url)
            forager.author = author.strip
            forager.tag = tag
            forager.channel = channel
            forager.save!
          end
          flag = 'y-3'
        end
        puts key.url if flag == 'f'
        key.is_processed = flag
        key.save!
      rescue => ex
        puts ex.message
        key.is_processed = 'error'
        key.save!
      end
    end
  end

  def forage_detail
    puts "forage"
    ForagerRunKey.where(is_processed: 'n').find_each do |key|
      begin
        doc = Nokogiri::HTML(open(key.url).read)

        post = ForagerPost.find_or_initialize_by(url: key.url)
        post.source = @source
        post.tag = key.tag
        post.channel = key.channel

        if main = doc.at(".read")
          title = main.at("h1")
          content = main.at(".readtext")
        end
        
        post.content = content.strip
        post.title = title.strip
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