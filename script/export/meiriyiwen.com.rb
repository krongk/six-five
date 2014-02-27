#encoding: utf-8
# == Usage
# > ruby migrate_data.rb 
# this script use to migrate local data to common.
# steps:
# 1. check local db
#		 format contenet to huxun/wenba_post_format
# => 	 add column is_exported to xx_post_format
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
	end
  
  def run
		puts 'start post...'
		i = 0
		begin
			begin
				url = "http://meiriyiwen.com/random"
				doc = Nokogiri::HTML(open(url).read)
				article = doc.at("div#article_show")
				title = article.at("h1").text
				author = article.at(".article_author").text
				text = article.at(".article_text").text
				post = ForagerPost.find_or_initialize_by(author: author, title: title)
				post.content = text.strip
				post.source = 'meiriyiwen.com'
				post.url = url
				post.save!
				i += 1
				puts title
				sleep(4)
			rescue => ex
				puts ex.message
				retry
			end
		end until i > 100000
	end
end

if __FILE__ == $0
  Forager.new.run
end