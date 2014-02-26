module ApplicationHelper
  #for tag cloud 
  include ActsAsTaggableOn::TagsHelper

  PAGE_PROPERTIES = [
    ['H', '头条'],
    ['C', '推荐'],
    ['F', '幻灯'],
    ['D', '底部'],
    ['S', '滚动'],
    ['B', '加粗'],
    ['P', '图片'],
    ['J', '跳转'],
  ]

  SPECIAL_SYMBO_REG = /(,|;|:|\.|\||\\|，|；|。|、)/

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def title(page_title)
    content_for(:title){ page_title}
  end
  def meta_keywords(meta_keywords)
    content_for(:meta_keywords){ meta_keywords}
  end
  def meta_description(meta_description)
    content_for(:meta_description){ meta_description}
  end
  def content(item_content)
    content_for(:content){ raw item_content }
  end

  ################################################
  #############helper for view####################
  #
  def get_date(date)
    date.strftime("%Y-%m-%d")
  end
  def get_short_content(content, count = 120)
    sanitize(strip_tags(content).to_s.truncate(count))
  end

  #use for Admin: preview id, production use short_title to cache.
  def get_preview_url(obj)
    if obj.class == Admin::Page
      "/#{obj.channel.id}/#{obj.id}"
    elsif obj.class == Admin::Channel
      "/#{obj.id}"
    else
      "/"
    end
  end
  #use for Frontpage: get production frontpage path
  def get_url(obj)
    if obj.class == Admin::Page
      "/#{obj.channel.short_title}/#{obj.id}"
    elsif obj.class == Admin::Channel
      "/#{obj.short_title}"
    else
      "/"
    end
  end

  #前台获得下拉列表菜单
  #默认调用方法：get_menu('product')
  #level: 显示的层级深度，默认为2级；如果要显示3级，则调用：get_menu('product', 3)
  def get_menu(channel_title_or_short_title, level = 1)
    parent_channel = Admin::Channel.find_by(short_title: channel_title_or_short_title)
    parent_channel ||= Admin::Channel.find_by(title: channel_title_or_short_title)
    return if parent_channel.nil? 
    if parent_channel.children.any? && (level = level - 1) >= 0
       str_arr = []
      str_arr << %{<li class="dropdown">}
      str_arr << %{<a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"> #{parent_channel.title} <b class="caret"></b></a>}
      str_arr << %{<ul class="dropdown-menu">}
      parent_channel.children.each do |ch|
        str_arr << get_menu(ch.short_title, level - 1)
      end
      str_arr << %{</ul></li>}
      str_arr.join("\n").html_safe
    else
      %{<li><a href="#{get_url(parent_channel)}">#{parent_channel.title}</a></li>}.html_safe
    end
  end

  #后台获得栏目列表(带层级关系)
  def get_admin_channel_list(parent_channel, ul_class, li_class)
    return if parent_channel.nil?
    if parent_channel.children.any?
      str_arr = []
      str_arr << %{<li class="#{li_class}">}
      str_arr << %{<a href="#{admin_channel_path(parent_channel)}"> #{parent_channel.title}</a> <i class="fa fa-caret-down"></i> }
      str_arr << %{<ul class="#{ul_class}">}
      parent_channel.children.each do |ch|
        str_arr << get_admin_channel_list(ch, ul_class, li_class)
      end
      str_arr << %{</ul></li>}
      str_arr.join("\n").html_safe
    else
      %{<li class="#{li_class}"><i class="fa fa-files-o"></i> <a href="#{admin_channel_path(parent_channel)}">#{parent_channel.title}</a></li>}.html_safe
    end
  end
  #this method used on admin/channel and admin/page create and update.
  # admin/channel_controller.rb
  # admin/page_controller.rb
  # short_title is used on URL, accept [a-zA-Z0-9-]
  def get_short_title(typo, title)
    return if title.blank?
    st = Pinyin.t(title).gsub(/(-|\s+)/, '-').gsub(/[^\w-]/, '')
    st = st.to_s.squeeze('-')[0..10].gsub(/\W+$/, '')
    case typo
    when 'channel'
      while Admin::Channel.where(short_title: st).any?
        st += ('a'..'z').to_a[rand(26)]
      end
    when 'page'
      while Admin::Page.where(short_title: st).any?
        st += ('a'..'z').to_a[rand(26)]
      end
    else
      raise "Please put typo ['channel', 'page'] on method get_short_title"
    end
    return st
  end

  #this method is to get content from default_url which channel has.
  # welcome/index.html.erb
  def get_templete_content(default_url)
    if !default_url.blank? && File.exist?(@base_dir + default_url)
      return File.open(@base_dir + default_url, 'r').read
    end
    '没有找到任何文件,请检查default_url是否设置正确'
  end

  #Tag 用以下的符号隔开都可以，就是不能用空格
  def update_tag(channel_or_page)
    #remove all previows
    channel_or_page.tag_list.clear
    #add new 
    channel_or_page.keywords.split(SPECIAL_SYMBO_REG).each do |tag|
      next if SPECIAL_SYMBO_REG.match tag
      channel_or_page.tag_list.add(tag)
      channel_or_page.save!
    end
  end

  #Pages slice 
  #将pages数组按照每count一组分组，用于frontpage特殊展示
  # [1,2,3,'a', 'b', 'c','d'] => [[1, 2, 3], ["a", "b", "c"], ["d"]]
  def get_slice_pages(pages, count)
    pages_dup = pages
    slice_pages = []
    while pages_dup.size > count do
      tmp_pages = pages_dup.slice(0, count)
      slice_pages << tmp_pages
      pages_dup = pages_dup - tmp_pages
    end
    slice_pages << pages_dup
    slice_pages
  end

end
