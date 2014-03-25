#encoding: utf-8
# 该文件的目的是组装模板文件
# 在Linux下运行，否则出现编码和操作权限问题。
#use $USAGE
$USAGE = <<EOT
 # 1. 请输入指定的模板文件名：-e theme
 # 2. 模板文件资源的文件结构为：
 #
 # |templete_name
 #        |assets
 #						|css
 #						|js
 #						|img
 #        |pages
 #        |index.html
 #				|t_blog_list.html
 #				|t_blog_detail.html
 #				|about.html
EOT

# mechanize lib
require 'rubygems'
require 'logger'
# command line argument parsing
require 'optparse'
require 'fileutils'
require 'pp'
require 'iconv'
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

    @ic = Iconv.new("UTF-8//IGNORE", "UTF-8")
  end
  
  def run
    error_flag = false
    puts "generate #{@theme}........."
		#0. dump theme folder
    #操作之前先备份
		puts "dump #{@theme} into #{@theme}_bak"
    base_dir = File.join(File.dirname(__FILE__), @theme)
    FileUtils.chmod(0777, base_dir)
    FileUtils.rmdir "#{@theme}_bak"
		FileUtils.cp_r @theme, "#{@theme}_bak"

    puts "\n =============== split index page --------------------"
    #1. split index page
    #首页将拆分为四个文本： 
    # <!-- [[head start]] --> ... <!-- [[head end]] -->
    # <!-- [[foot start]] --> ... <!-- [[foot end]] -->
    # <!-- [[header start]] --> ... <!-- [[header end]] -->
    # <!-- [[footer start]] --> ... <!-- [[footer end]] -->
    index_path = File.join(File.dirname(__FILE__), @theme, 'index.html')
    head_path = File.join(File.dirname(__FILE__), @theme, '_head.html')
    header_path = File.join(File.dirname(__FILE__), @theme, '_header.html')
    foot_path = File.join(File.dirname(__FILE__), @theme, '_foot.html')
    footer_path = File.join(File.dirname(__FILE__), @theme, '_footer.html')
    temp_index_path = File.join(File.dirname(__FILE__), @theme, 'temp_index.html')
    puts "can not find index page #{error_flag = true}" unless File.exists?(index_path)
    return if error_flag

    index_content = File.open(index_path).read
    index_content = @ic.iconv(index_content)
    #index_content.delete!("^\u{0000}-\u{007F}")
    %W[head foot header footer].each do |s|
      if /<!--\s*\[\[#{s} start\]\]\s*-->(.*)<!--\s*\[\[#{s} end\]\]\s*-->/im =~ index_content.force_encoding("utf-8")
        the_content = $1
        File.open(eval("#{s}_path"), 'w'){|f| f.write( get_content(the_content) )}
        puts s
      else
        raise "error to find: <!-- [[#{s} start]] -->"
      end
    end

    if /<\/head>(.*)<\/html>/im =~ index_content.force_encoding("utf-8")
      puts "create temp_index.html"
      the_content = $1
      %W[header footer].each do |s|
        the_content = the_content.sub(/<!--\s*\[\[#{s} start\]\]\s*-->(.*)<!--\s*\[\[#{s} end\]\]\s*-->/im, "<%= render file: 'public/templetes/#{@theme}/_#{s}.html' %>")
      end
      #remove foot from body
      the_content = the_content.sub(/<!--\s*\[\[foot start\]\]\s*-->(.*)<!--\s*\[\[foot end\]\]\s*-->/im, '')
      
      File.open(temp_index_path, 'w'){|f| f.write( get_content(the_content) )}
    end

    #2. extract templete pages
    #模版文件必须以“t_hh.html"打头
    #模版文件抽取策略：
    # 1. 获取<body>部分的内容
    # 2. 去除<body>部分中的一下内容
    #   <!-- [[header start]] --> ... <!-- [[header end]] -->
    #   <!-- [[footer start]] --> ... <!-- [[footer end]] -->
    puts "\n =============== extract templete pages--------------------"
    Dir.chdir(base_dir)
    temp_list = Dir.glob("*.html")

    temp_list.each do |t|
      next if t !~ /^(?:t|temp)_(.*)$/i
      f_name = $1
      puts t

      the_content = File.open(t).read
      if /<body[^>]*>(.*)<\/body>/im =~ the_content.force_encoding("utf-8")
        the_content = $1
        %W[header footer].each do |s|
          the_content = the_content.sub(/<!--\s*\[\[#{s} start\]\]\s*-->(.*)<!--\s*\[\[#{s} end\]\]\s*-->/im, "<%= render file: 'public/templetes/#{@theme}/_#{s}.html' %>")
        end
        #create a new temp file temp_blog_detail.html
        File.open("temp_#{f_name}", 'w'){|f| f.write( get_content(the_content) )}

        #remove original file t_blog_detail.html
        FileUtils.rm [t] if t =~ /^t_.*$/i
      else
        raise "#{t} can not extract"
      end
    end

    #3. extract other single page content
    #去除其他只保留body部分的main部分：
    # <!-- [[main start]] --> ... <!-- [[main end]] -->
    puts "\n =============== extract other single page--------------------"
    temp_list = Dir.glob("*.html")
    temp_list.each do |t|
      next if t =~ /^(?:t|temp)_(.*)$/i
      puts t

      the_content = File.open(t).read
      if /<!--\s*\[\[main start\]\]\s*-->(.*)<!--\s*\[\[main end\]\]\s*-->/im =~ the_content.force_encoding("utf-8")
        the_content = $1
        File.open(t, 'w'){|f| f.write( get_content(the_content) )}
      end
    end

    #4. format css's image path
    css_list = Dir.glob(File.join("**", "*.css"))
    css_list.each do |css|
      the_content = File.open(css).read
      File.open(css, 'w'){|f| f.write( get_content(the_content.force_encoding("utf-8")) )}
    end

    puts "\n\n............down!........."
    exit
  end

  #assets:
  # <img src="assets/img
  # <script src="assets/js/b
  # <link href="assets/
  # <img src="images/
  #css:
  # url(../../images/down.png)
  # background:url(/templetes
  # url(/templetes/
  # background: url(
  def get_content(content)
    content = @ic.iconv(content)
    content = content.force_encoding("utf-8")
    content.gsub!(/ src\s*=\s*"(assets|img|images|image|js|javascript|javascripts|css|font|fonts|ico|icos|icon|icons)\//, ' src="/templetes/{{theme}}/\1/')
    content.gsub!(/ href\s*=\s*"(assets|img|images|image|js|javascript|javascripts|css|font|fonts|icos|icons|ico|icon)\//, ' href="/templetes/{{theme}}/\1/')
    #css
    content.gsub!(/url\(['".\/]*((assets|img|images|image|font|fonts|social-icons|icos|icons|ico|icon)[^\)]+(jpg|jpefg|gif|png))['"]\)/, 'url("/templetes/{{theme}}/\1")')
    content.gsub!(/\{\{theme\}\}/, "#{@theme}")
    content
  end
end

#run script
DataExtractor.new(ARGV).run if __FILE__ == $0
