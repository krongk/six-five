#encoding: utf-8
class Admin::TempletesController < Admin::ApplicationController
  def index
  end

  def show
  end

  def new
    @templetes = Dir.glob "#{Rails.root}/public/templetes/*"
  end

  def create
    Admin::Keystore.put('templete', params[:templete])
    #Admin::Keystore.put('head', params[:head])
    #Admin::Keystore.put('foot', params[:foot])
    #input layouts/_header
    File.open( File.join(Rails.root, "/app/views/layouts/_header.html.erb"), 'w') do |f|
      f.write File.open( File.join(@base_dir, '_header.html'), 'r').read
    end
    File.open( File.join(Rails.root, "/app/views/layouts/_footer.html.erb"), 'w') do |f|
      f.write File.open( File.join(@base_dir, '_footer.html'), 'r').read
    end
    redirect_to "/admin/templetes/index", notice: "添加成功"
  end

  def edit
    @file = File.join(@base_dir, params[:f])
    @file_content = File.open(@file, 'r').read
  end

  def update
    #only admin can modify templtes
    unless current_user.has_role?(:admin)
      redirect_to "/admin/templetes/index", alert: "没有修改权限"
      return
    end

    @file = File.join(@base_dir, params[:f])
    File.open(@file, 'w'){|f| f.write(params[:content])}
    redirect_to "/admin/templetes/index", notice: "更新成功"
    expire_cache
  end

  def destroy
  end

  def update_cache
    logger.info "expire cache"
    expire_cache
    logger.info "reload nginx"
    `/alidata/server/nginx/sbin/nginx -s reload`
    flash[:notice] = "系统缓存更新成功。"
  end

  private
  #if update templete, expire all cache pages
  def expire_cache
    cache_page_dir = File.join(Rails.root, 'public', 'page_cache')
    FileUtils.rm_rf cache_page_dir 
    logger.info "cache expire dir: #{cache_page_dir}, #{!File.directory?(cache_page_dir)}"
  end

end
