class ApplicationController < ActionController::Base
  include ApplicationHelper
  #add page cache
  include ActionController::Caching::Pages
  self.page_cache_directory = "#{Rails.root.to_s}/public/page_cache"
  #traffic_counter
  before_filter :increase_traffic_counter

  TRAFFIC_DECREMENTER = 0.15

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :load_templete

  #catch exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => '没有权限访问，请联系管理员！'
  end
  rescue_from ActionController::RoutingError do |exception|
    redirect_to root_path
  end

  def increase_traffic_counter
    @traffic = 1.0

    if user_is_spider? || [ "json", "rss" ].include?(params[:format])
      return true
    end

    Admin::Keystore.transaction do
      date = (Admin::Keystore.value_for("traffic:date").to_i || Time.now.to_i)
      traffic = (Admin::Keystore.incremented_value_for("traffic:hits", 0).
        to_f / 100.0) + 1.0

      # every second, decrement traffic by some amount
      @traffic = [ 1.0, traffic.to_f -
        ((Time.now.to_i - date) * TRAFFIC_DECREMENTER) ].max

      Admin::Keystore.put("traffic:date", Time.now.to_i)
      Admin::Keystore.put("traffic:hits", (@traffic * 100.0).to_i)
    end

    Rails.logger.info "  Traffic level: #{@traffic}"

    true
  end

  #detect if a mobile device
  def mobile_device?
   !!(request.user_agent =~ /Mobile|webOS/)
  end
  helper_method :mobile_device?

  def user_is_spider?
    !!request.env["HTTP_USER_AGENT"].to_s.match(/Googlebot/)
  end
  helper_method :user_is_spider?

  #this method initlize global variables.
  def load_templete
    @templete = Admin::Keystore.value_for('templete')
    @templete ||= 'default'
    @base_dir = "#{Rails.root}/public/templetes/#{@templete}/"
    Dir.chdir(@base_dir)
    @temp_list = Dir.glob("*.html").sort

    tempfiles = File.join(Rails.root, "public", "ckeditor_assets", "**", "*.{jpg, png, gif, jpeg}")
    @image_list = Dir.glob([tempfiles]).map{|i| i.sub(/^.*\/public/, '') }.sort
    @image_list = @image_list.select{|i| i =~ /thumb_/i}
  end

  #render 404 error
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
