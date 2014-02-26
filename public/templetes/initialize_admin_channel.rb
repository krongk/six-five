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
 :database => 'zhixin' 
)

class AdminChannel < LocalTableBase
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
      :tmp_index    => 'temp_index.html',
      :tmp_detail   => nil,
      :keywords     => '智信家具,桑拿沙发,足浴沙发,浴足床,洗脚床,按摩床,美容床',
      :description  => '智信家具专业生产桑拿沙发、足浴沙发,电动足浴沙发,浴足沙发、浴足床、洗脚床,足疗床,按摩床等产品'
    )
    #2
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'product',
      :title        => '智信产品',
      :short_title  => 'product',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '智信产品',
      :description  => '智信产品'
    )
    #3
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'article',
      :title        => '配套服务',
      :short_title  => 'service',
      :properties   => 1,
      :tmp_index    => 'temp_service_index.html',
      :tmp_detail   => 'temp_service_detail.html',
      :default_url  => nil,
      :keywords     => '智信配套服务',
      :description  => '智信配套服务'
    )
    #4
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'article',
      :title        => '关于我们',
      :short_title  => 'about',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '关于智信家具',
      :description  => '关于智信家具'
    )
    #5
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'article',
      :title        => '服务网络',
      :short_title  => 'net',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具，服务网络，成都智信家具，重庆智信家具，贵阳智信家具',
      :description  => '智信家具设有成都智信家具总部，重庆智信家具分部和贵阳智信家具分部'
    )
    #6
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'product',
      :title        => '成功案例',
      :short_title  => 'portfolio',
      :properties   => 1,
      :tmp_index    => 'temp_portfolio_index.html',
      :tmp_detail   => 'temp_portfolio_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具成功案例展示',
      :description  => '智信家具成功案例展示'
    )
    #7
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'article',
      :title        => '智信资讯',
      :short_title  => 'news',
      :properties   => 1,
      :tmp_index    => 'temp_blog_index.html',
      :tmp_detail   => 'temp_blog_detail.html',
      :default_url  => nil,
      :keywords     => '智信资讯,智信家具新闻资讯，西部家具行业动态',
      :description  => '智信资讯提供智信家具新闻资讯，西部家具行业动态，智信公司新闻等家具资讯'
    )
    #8
    AdminChannel.create!(
      :parent_id    => nil,
      :typo         => 'article',
      :title        => '帮助中心',
      :short_title  => 'help',
      :properties   => 1,
      :tmp_index    => 'temp_default.html',
      :tmp_detail   => 'temp_default.html',
      :default_url  => nil,
      :keywords     => '智信家具帮助中心',
      :description  => '智信家具帮助中心'
    )
    #2-1
    AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '桑拿沙发、足浴沙发',
      :short_title  => 'product-sofa',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '桑拿沙发、足浴沙发',
      :description  => '桑拿沙发、足浴沙发'
    )
    #2-2
    AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '浴足床、洗脚床、足浴床',
      :short_title  => 'product-bed',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '浴足床、洗脚床、足浴床',
      :description  => '浴足床、洗脚床、足浴床'
    )
    #2-3
    AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '按摩床、美容床',
      :short_title  => 'product-massage',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '按摩床、美容床',
      :description  => '按摩床、美容床'
    )
    #2-4
    AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '洗浴休闲茶几',
      :short_title  => 'product-teapot',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '洗浴休闲茶几',
      :description  => '洗浴休闲茶几'
    )
    #2-5
    AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '美甲沙发',
      :short_title  => 'product-nailsofa',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '美甲沙发',
      :description  => '美甲沙发'
    )
    #2-6
    AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '浴足盆',
      :short_title  => 'product-washpot',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '浴足盆',
      :description  => '浴足盆'
    )
    #2-7
    AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '洗浴配套电视系统',
      :short_title  => 'product-tv',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '洗浴配套电视系统',
      :description  => '洗浴配套电视系统'
    )
      AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '专业电视机',
      :short_title  => 'product-tv1',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '专业电视机',
      :description  => '专业电视机'
    )
      AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '控制器及控制面板',
      :short_title  => 'product-tv2',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '控制器及控制面板',
      :description  => '控制器及控制面板'
    )
      AdminChannel.create!(
      :parent_id    => 2,
      :typo         => 'product',
      :title        => '电视支架',
      :short_title  => 'product-tv3',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '电视支架',
      :description  => '电视支架'
    )
    #3-1
    AdminChannel.create!(
      :parent_id    => 3,
      :typo         => 'article',
      :title        => '保健按摩技师考证',
      :short_title  => 'service-Massager',
      :properties   => 1,
      :tmp_index    => 'temp_service_index.html',
      :tmp_detail   => 'temp_service_detail.html',
      :default_url  => nil,
      :keywords     => '保健按摩技师考证',
      :description  => '保健按摩技师考证'
    )
    AdminChannel.create!(
      :parent_id    => 3,
      :typo         => 'article',
      :title        => '芳香培训师考证',
      :short_title  => 'service-Aromatic',
      :properties   => 1,
      :tmp_index    => 'temp_service_index.html',
      :tmp_detail   => 'temp_service_detail.html',
      :default_url  => nil,
      :keywords     => '芳香培训师考证',
      :description  => '芳香培训师考证'
    )
    AdminChannel.create!(
      :parent_id    => 3,
      :typo         => 'article',
      :title        => '足疗用品',
      :short_title  => 'product-foot',
      :properties   => 1,
      :tmp_index    => 'temp_product_list.html',
      :tmp_detail   => 'temp_product_detail.html',
      :default_url  => nil,
      :keywords     => '足疗用品',
      :description  => '足疗用品'
    )
    #4-1
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '智信简介',
      :short_title  => 'jianjie',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '公司简介',
      :description  => '公司简介'
    )
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '智信荣誉',
      :short_title  => 'rongyu',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信荣誉',
      :description  => '智信荣誉'
    )
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '工艺流程',
      :short_title  => 'gongyi',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具生产工艺流程',
      :description  => '智信家具生产工艺流程'
    )
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '材质保证',
      :short_title  => 'caizhi',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信材质保证',
      :description  => '智信材质保证'
    )
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '品质保证',
      :short_title  => 'pinzhi',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信品质保证',
      :description  => '智信品质保证'
    )
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '服务保证',
      :short_title  => 'fuwu',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信服务保证',
      :description  => '智信服务保证'
    )
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '产品交货期',
      :short_title  => 'jiaohuo',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具产品交货期',
      :description  => '智信家具产品交货期'
    )
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '服务流程',
      :short_title  => 'liucheng',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具服务流程',
      :description  => '智信家具服务流程'
    )
    AdminChannel.create!(
      :parent_id    => 4,
      :typo         => 'article',
      :title        => '智信风采',
      :short_title  => 'fengcai',
      :properties   => 1,
      :tmp_index    => 'temp_blog_index.html',
      :tmp_detail   => 'temp_blog_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具公司风采，智信家具员工风采',
      :description  => '智信家具公司风采，智信家具员工风采'
    )
    #5-1
    AdminChannel.create!(
      :parent_id    => 5,
      :typo         => 'article',
      :title        => '成都服务中心',
      :short_title  => 'net-chengdu',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具，服务网络，成都智信家具，智信家具成都服务中心',
      :description  => '智信家具成都服务中心, 服务中心联系电话：400-633-5189'
    )
    AdminChannel.create!(
      :parent_id    => 5,
      :typo         => 'article',
      :title        => '重庆服务中心',
      :short_title  => 'net-chongqing',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具，服务网络，重庆智信家具，智信家具重庆服务中心',
      :description  => '智信家具重庆服务中心, 服务中心联系电话：400-633-5189'
    )
    AdminChannel.create!(
      :parent_id    => 5,
      :typo         => 'article',
      :title        => '贵阳服务中心',
      :short_title  => 'net-chongqing',
      :properties   => 1,
      :tmp_index    => 'temp_article_index.html',
      :tmp_detail   => 'temp_article_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具，服务网络，贵阳智信家具，智信家具贵阳服务中心',
      :description  => '智信家具贵阳服务中心, 服务中心联系电话：400-633-5189'
    )

    #6-1
    AdminChannel.create!(
      :parent_id    => 6,
      :typo         => 'product',
      :title        => '四川地区',
      :short_title  => 'portfolio-sichuang',
      :properties   => 1,
      :tmp_index    => 'temp_portfolio_index.html',
      :tmp_detail   => 'temp_portfolio_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具四川地区成功案例',
      :description  => '智信家具四川地区成功案例'
    )
    AdminChannel.create!(
      :parent_id    => 6,
      :typo         => 'product',
      :title        => '贵州地区',
      :short_title  => 'portfolio-guizhou',
      :properties   => 1,
      :tmp_index    => 'temp_portfolio_index.html',
      :tmp_detail   => 'temp_portfolio_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具贵州地区成功案例',
      :description  => '智信家具贵州地区成功案例'
    )
    AdminChannel.create!(
      :parent_id    => 6,
      :typo         => 'product',
      :title        => '重庆地区',
      :short_title  => 'portfolio-chongqing',
      :properties   => 1,
      :tmp_index    => 'temp_portfolio_index.html',
      :tmp_detail   => 'temp_portfolio_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具重庆地区成功案例',
      :description  => '智信家具重庆地区成功案例'
    )
    AdminChannel.create!(
      :parent_id    => 6,
      :typo         => 'product',
      :title        => '西藏及其他地区',
      :short_title  => 'portfolio-tibet',
      :properties   => 1,
      :tmp_index    => 'temp_portfolio_index.html',
      :tmp_detail   => 'temp_portfolio_detail.html',
      :default_url  => nil,
      :keywords     => '智信家具西藏及其他地区成功案例',
      :description  => '智信家具西藏及其他地区成功案例'
    )
    #8-1
    AdminChannel.create!(
      :parent_id    => 8,
      :typo         => 'article',
      :title        => '常见问题',
      :short_title  => 'faq',
      :properties   => 1,
      :tmp_index    => 'temp_default.html',
      :tmp_detail   => 'temp_default.html',
      :default_url  => nil,
      :keywords     => '智信家具常见问题,常见问题',
      :description  => '智信家具帮助中心,常见问题'
    )
    AdminChannel.create!(
      :parent_id    => 8,
      :typo         => 'article',
      :title        => '意见反馈',
      :short_title  => 'form1',
      :properties   => 1,
      :tmp_index    => 'temp_default.html',
      :tmp_detail   => 'temp_default.html',
      :default_url  => nil,
      :keywords     => '智信家具常见问题,意见反馈',
      :description  => '智信家具帮助中心,意见反馈'
    )
    #7-1
    AdminChannel.create!(
      :parent_id    => 7,
      :typo         => 'article',
      :title        => '智信新闻',
      :short_title  => 'zhixin-news',
      :properties   => 1,
      :tmp_index    => 'temp_blog_index.html',
      :tmp_detail   => 'temp_blog_detail.html',
      :default_url  => nil,
      :keywords     => '智信新闻,智信家具新闻资讯，西部家具行业动态',
      :description  => '智信资讯提供智信家具新闻资讯，西部家具行业动态，智信公司新闻等家具资讯'
    )
    AdminChannel.create!(
      :parent_id    => 7,
      :typo         => 'article',
      :title        => '行业动态',
      :short_title  => 'jiaju-news',
      :properties   => 1,
      :tmp_index    => 'temp_blog_index.html',
      :tmp_detail   => 'temp_blog_detail.html',
      :default_url  => nil,
      :keywords     => '智信新闻,行业动态,智信家具新闻资讯，西部家具行业动态',
      :description  => '智信资讯提供智信家具新闻资讯,行业动态,西部家具行业动态,智信公司新闻等家具资讯'
    )
    AdminChannel.create!(
      :parent_id    => 7,
      :typo         => 'article',
      :title        => '客户评价',
      :short_title  => 'customer-reviews',
      :properties   => 1,
      :tmp_index    => 'temp_blog_index.html',
      :tmp_detail   => 'temp_blog_detail.html',
      :default_url  => nil,
      :keywords     => '智信客户评价,客户评价,智信家具新闻资讯，西部家具行业动态',
      :description  => '智信资讯提供智信家具新闻资讯,客户评价,西部家具行业动态,智信公司新闻等家具资讯'
    )
    puts "done!"
  end
end


#run script
DataExtractor.new(ARGV).run if __FILE__ == $0

# NSERT INTO admin_channels(parent_id, typo, title, short_title, properties, default_url, tmp_index, tmp_detail, keywords, description)
# VALUES(NULL, 'article', '首页', 'index', 1, NULL, 'temp_index.html', '', '首页', '首页');
