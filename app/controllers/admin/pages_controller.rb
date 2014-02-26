class Admin::PagesController < Admin::ApplicationController
  before_action :set_admin_page, only: [:show, :edit, :update, :destroy]

  # GET /admin/pages
  # GET /admin/pages.json
  def index
    @admin_pages = Admin::Page.order("updated_at DESC").page(params[:page])
  end

  # GET /admin/pages/1
  # GET /admin/pages/1.json
  def show
  end

  # GET /admin/pages/new
  def new
    @admin_page = Admin::Page.new
  end

  # GET /admin/pages/1/edit
  def edit
  end

  # POST /admin/pages
  # POST /admin/pages.json
  def create
    @admin_page = Admin::Page.new(admin_page_params)
    @admin_page.user_id = current_user.id
    @admin_page.short_title = get_short_title('page', @admin_page.title) if @admin_page.short_title.blank?
    respond_to do |format|
      if @admin_page.save
        update_tag(@admin_page)

        format.html { redirect_to admin_pages_path, notice: '页面添加成功！' }
        format.json { render action: 'show', status: :created, location: @admin_page }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/pages/1
  # PATCH/PUT /admin/pages/1.json
  def update
    #only user can modify 
    unless current_user.has_role?(:admin) || current_user.has_role?(:user)
      redirect_to admin_pages_path, alert: "没有权限"
      return
    end
    @admin_page.user_id = current_user.id
    respond_to do |format|
      if @admin_page.update(admin_page_params)
        update_tag(@admin_page)
        if @admin_page.short_title.blank?
          @admin_page.short_title = get_short_title('page', @admin_page.title)
          @admin_page.save!
        end

        format.html { redirect_to admin_pages_path, notice: '页面更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/pages/1
  # DELETE /admin/pages/1.json
  def destroy
    #only user can modify 
    unless current_user.has_role?(:admin) || current_user.has_role?(:user)
      redirect_to admin_pages_path, alert: "没有权限"
      return
    end
    @admin_page.destroy
    respond_to do |format|
      format.html { redirect_to admin_pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_page
      @admin_page = Admin::Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_page_params
      params.require(:admin_page).permit(:user_id, :channel_id, :title, :short_title, :properties, :keywords, 
        :description, :image_path, :content,
        :tag_id, :context, :taggable)
    end
end
