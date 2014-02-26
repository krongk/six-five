#encoding: utf-8
# 该文件的目的是生成一个指定文件名的空模板文件夹结构

$USAGE = <<EOT
 # 1. 请输入指定的模板文件名：-e theme
 # 2. 模板文件资源的文件结构为：
 #
 # |theme_name
 #        |assets
 #              _footer.html
 #              _header.html
 #              _index_content.html
 #              css_urls.txt
 #              js_urls.txt
 #        |css
 #        |js
 #        |img
 #        |pages
 #            |blog.html
 #            |post.html
 #        |demo.default.html   
EOT


require 'rubygems'
require 'logger'
require 'optparse'
require 'pp'
require "fileutils"

# re-use Exception
class Exception
  attr_accessor :method_name
end

class ExtractException < Exception ; end

# define main class
class DataExtractor
  def print_and_exit(msg)
      puts
      puts '*** ERROR ***'
      puts msg
      puts
      exit
  end
  
  def initialize(args)
    print_and_exit($USAGE) if args.length == 0
    
    opt = OptionParser.new
    opt.on('-h', '--help') { print_and_exit($USAGE)}
    opt.on('-e', '--theme theme') { |theme| @theme = theme.downcase }
    opt.parse!(args)
    print_and_exit('please provide theme name with -e <theme>') if @theme.nil?
  end
  
  def run
    puts "generate #{@theme}........."

    #1. create folder
    FileUtils::mkdir_p "#{@theme}/assets"
    FileUtils::mkdir_p "#{@theme}/css"
    FileUtils::mkdir_p "#{@theme}/js"
    FileUtils::mkdir_p "#{@theme}/img"
    FileUtils::mkdir_p "#{@theme}/pages"
    #2.create file
    css_urls_path = File.join(File.dirname(__FILE__), @theme, 'assets', 'css_urls.txt')
    js_urls_path = File.join(File.dirname(__FILE__), @theme, 'assets', 'js_urls.txt')
    header_path = File.join(File.dirname(__FILE__), @theme, 'assets', '_header.html')
    index_content_path = File.join(File.dirname(__FILE__), @theme, 'assets', '_index_content.html')
    footer_path = File.join(File.dirname(__FILE__), @theme, 'assets', '_footer.html')
    blog_path = File.join(File.dirname(__FILE__), @theme, 'pages', 'blog.html')
    post_path = File.join(File.dirname(__FILE__), @theme, 'pages', 'post.html')
    
    File.open(css_urls_path, "w+") { |file| file.write("\n") }
    File.open(js_urls_path, "w+") { |file| file.write("\n") }
    File.open(header_path, "w+") { |file| file.write("\n") }
    File.open(index_content_path, "w+") { |file| file.write("\n") }
    File.open(footer_path, "w+") { |file| file.write("\n") }
    File.open(blog_path, "w+") { |file| file.write("\n") } unless File.exists?(blog_path)
    File.open(post_path, "w+") { |file| file.write("\n") }
    #3. copy default example file
    FileUtils.cp_r( "myway/demo.default.html", "#{@theme}/demo.default.html" )
    
    puts "down"
    exit
  end

end

#run script
DataExtractor.new(ARGV).run if __FILE__ == $0