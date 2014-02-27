#encoding: utf-8
# == Usage
# > ruby migrate_data.rb 
# this script use to migrate local data to common.
# steps:
# 1. check local db
#		 format contenet to huxun/wenba_post_format
# => 	 add column is_migrated to xx_post_format
# 2. run migrater.rb 

$:.unshift(File.dirname(__FILE__))
require "rubygems"
require "local_tables"
require "pp"
require 'chinese_pinyin'

class Migrator
	def initialize
	end
  
	def migrate(post)
		begin
		  page = AdminPage.find_or_initialize_by(title: post.title, author: post.author)
		  page.content = post.content.gsub(/(\r\n){2,}/, "<br>\n").gsub(/\r\n/, "<br>\n").gsub(/\n/, "<br>\n")
		  #［英国］达纳·左哈　伊恩·马歇尔
		  page.keywords = post.author.strip
		  #page.short_title = Pinyin.t(post.title)
		  page.user_id = 1
		  page.channel_id = 3
		  page.save!

		  post.is_migrated = 'y'
		  post.save!
		rescue => ex
			puts ex.message
			post.is_migrated = 'f'
		  post.save!
		end
	end

	def run
		puts 'start post...'
		ForagerPost.where(is_migrated: 'n').find_each do |post|
			migrate(post)
			puts post.id
		end
		puts 'done...'
	end
end

if __FILE__ == $0
  Migrator.new.run
end