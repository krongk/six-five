#encoding: utf-8
require 'rubygems'
require 'optparse'
require 'active_record'

class LocalTableBase < ActiveRecord::Base
  self.abstract_class = true
  # self.pluralize_table_names = false
end

LocalTableBase.establish_connection(
 :adapter => 'mysql2',
 :reconnect => true,
 :wait_timeout => 600,
 :pool => 50,
 :username => 'root',
 :password => 'kenrome001',
 :host => 'localhost',
 :port => 3306,
 :database => 'six_five' 
)

class AdminChannel < LocalTableBase
end
class AdminPage < LocalTableBase
end

# define main class
class DataExtractor

  def initialize(args)
    print_and_exit($USAGE) if args.length == 0
    
    opt = OptionParser.new
    opt.on('-h', '--help') { print_and_exit($USAGE)}
    opt.on('-e', '--theme theme') { |theme| @theme = theme.downcase }
    opt.parse!(args)
    print_and_exit('please provide theme name with -e <theme>') if @theme.nil?
  end
  
  def run
    #在这里填写没个栏目内容, 先创建父级栏目，再添加子级
    puts "truncate tables"
    AdminChannel.connection.execute("truncate table admin_channels")
    AdminChannel.connection.execute("truncate table admin_pages")
    AdminChannel.connection.execute("truncate table taggings")
    AdminChannel.connection.execute("truncate table tags")

    puts "create new channel"
    #1
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'article',
      :title        => '首页',
      :short_title  => 'index',
      :properties   => 1,
      :default_url  => nil,
      :tmp_index    => 'temp_article_detail.html',
      :tmp_detail   => 'temp_article_detail.html',,
      :keywords     => '六五微文学：微写作,微小说,微语录,微笑话,微诗歌,微观点,微情书',
      :description  => '六五微文学网收录微写作,微小说,微语录,微笑话,微诗歌,微观点,微情书'
    )
    #2
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'article',
      :title        => '关于',
      :short_title  => 'about',
      :properties   => 1,
      :tmp_index    => 'temp_article_detail.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '六五微文学网',
      :description  => '六五微文学网'
    )
    AdminPage.create!(
      :user_id => 1,
      :channel_id => 2,
      :title => '关于六五微文学网'
      :short_title => 'about'
      :content => '关于'
    )
    #3
   AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'article',
      :title        => '频道',
      :short_title  => 'channel',
      :properties   => 1,
      :default_url  => nil,
      :tmp_index    => 'temp_tag_list.html',
      :tmp_detail   => 'temp_article_detail.html',
      :keywords     => '发布微写作，微语录，微语体，微录体，微散文，微随笔',
      :description  => '六五微文学发布微写作，微语录，微语体，微录体，微散文，微随笔'
    )
   
    #5
    AdminChannel.create!(
      :parent_id    => 3,
      :typo         => 'article',
      :title        => '微写作',
      :short_title  => 'writing',
      :properties   => 1,
      :default_url  => nil,
      :tmp_index    => 'temp_tag_list.html',
      :tmp_detail   => 'temp_article_detail.html',
      :keywords     => '发布微写作，微语录，微语体，微录体，微散文，微随笔',
      :description  => '六五微文学发布微写作，微语录，微语体，微录体，微散文，微随笔'
    )
    AdminChannel.create!(
          :parent_id    => 3,
          :typo         => 'article',
          :title        => '微小说',
          :short_title  => 'story',
          :properties   => 1,
          :default_url  => nil,
          :tmp_index    => 'temp_tag_list.html',
          :tmp_detail   => 'temp_article_detail.html',
          :keywords     => '收录微型小说，微故事，微寓言，微小品，微剧本',
          :description  => '六五微文学收录微型小说，微故事，微寓言，微小品，微剧本'
        )
    AdminChannel.create!(
          :parent_id    => 3,
          :typo         => 'article',
          :title        => '微语录',
          :short_title  => 'quote',
          :properties   => 1,
          :default_url  => nil,
          :tmp_index    => 'temp_tag_list.html',
          :tmp_detail   => 'temp_article_detail.html',
          :keywords     => '收录名言警句，箴言佳句，微名言，微语录',
          :description  => '六五微文学收录名言警句，箴言佳句，微名言，微语录'
        )
    AdminChannel.create!(
          :parent_id    => 3,
          :typo         => 'article',
          :title        => '微笑话',
          :short_title  => 'joke',
          :properties   => 1,
          :default_url  => nil,
          :tmp_index    => 'temp_tag_list.html',
          :tmp_detail   => 'temp_article_detail.html',
          :keywords     => '收录微笑话，微糗事',
          :description  => '六五微文学收录微笑话，微糗事'
        )
    AdminChannel.create!(
          :parent_id    => 3,
          :typo         => 'article',
          :title        => '微诗歌',
          :short_title  => 'poem',
          :properties   => 1,
          :default_url  => nil,
          :tmp_index    => 'temp_tag_list.html',
          :tmp_detail   => 'temp_article_detail.html',
          :keywords     => '收录微型诗，微歌词，诗歌体文字内容',
          :description  => '六五微文学收录微型诗，微歌词，诗歌体文字内容'
        )
    AdminChannel.create!(
          :parent_id    => 3,
          :typo         => 'article',
          :title        => '微观点',
          :short_title  => 'news',
          :properties   => 1,
          :default_url  => nil,
          :tmp_index    => 'temp_tag_list.html',
          :tmp_detail   => 'temp_article_detail.html',
          :keywords     => '收录实事品评，新闻点评，微新闻，微实事，微视角、微悦读，微人物。',
          :description  => '六五微文学收录实事品评，新闻点评，微新闻，微报道，微实事，微视角、微悦读，微人物。'
        )
    AdminChannel.create!(
          :parent_id    => 3,
          :typo         => 'article',
          :title        => '微情书',
          :short_title  => 'love',
          :properties   => 1,
          :default_url  => nil,
          :tmp_index    => 'temp_tag_list.html',
          :tmp_detail   => 'temp_article_detail.html',
          :keywords     => '收录微爱情，微日记，微插画，微笔记，记录爱碎念',
          :description  => '六五微文学  收录微爱情，微日记，微插画，微笔记，记录爱碎念'
        )

    puts "done!"
  end
end


#run script
DataExtractor.new(ARGV).run if __FILE__ == $0

# NSERT INTO admin_channels(parent_id, typo, title, short_title, properties, default_url, tmp_index, tmp_detail, keywords, description)
# VALUES(NULL, 'article', '首页', 'index', 1, NULL, 'temp_index.html', '', '首页', '首页');
