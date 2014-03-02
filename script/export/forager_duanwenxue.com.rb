#encoding: utf-8
# http://www.duanwenxue.com/article/1.html => http://www.duanwenxue.com/article/212061.html

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
    @source = 'duanwenxue.com'
  end
  
  def run
    puts 'start post...'
    last_post = ForagerPost.where(source: @source).order("id desc").first
    index = 1 
    index = $1 if last_post && last_post.url =~ /http:\/\/www.duanwenxue.com\/article\/(\d+).html/i
    puts index
    index = index.to_i
    total_count = index + 10
    begin
      begin
        index += 1
        url = "http://www.duanwenxue.com/article/#{index}.html"
        doc = Nokogiri::HTML(open(url).read)
        main = doc.at("div.main-left")
        begin
          channel = main.at("div.content-nav h2").text
          title = main.at("div.content-title h1").text.gsub(/\s+/, ' ')
          author = main.at("div.content-title .writer span")
          author.search("a").remove
          author = author.text
          #作者: 心  ` []作者: 心  ` []
          author = author.sub(/作者:/, '').gsub(/\[|\]|\s*/, '')
          author = author.strip
          rant_count = main.at("div.content-title .writer span .read").text
        rescue => ex1
          puts "error on author:"
          puts ex1
        end
        content = main.at("div.content")
        content.search("p.space").remove
        content.search("div.content-in-top").remove
        content.search("div.content-in-bottom").remove
        text = content.text
          post = ForagerPost.find_or_initialize_by(author: author, title: title)
          post.source = @source
          post.content = text.strip
          post.channel = channel
          post.page_html = main.text
          post.url = url
          post.save!
        puts url
      rescue => ex
        puts ex.message
        index += 1
        retry
      end
    end until index > total_count
   
  end
end

if __FILE__ == $0
  Forager.new.run
end