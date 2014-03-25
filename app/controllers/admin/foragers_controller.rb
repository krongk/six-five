class Admin::ForagersController < ApplicationController
  before_action :set_admin_forager, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:new, :create]

  # GET /admin/foragers
  # GET /admin/foragers.json
  def index
    #build search query
    queries     = []
    conditions  = []
    if params[:source].present?
      queries     << 'source = ?'
      conditions  << params[:source]
    end
    if params[:author].present?
      queries     << "author like ? "
      conditions  << "%#{params[:author]}%"
    end
    if params[:title].present?
      queries     << "title like ?"
      conditions  << "%#{params[:title]}%"
    end
    conditions.unshift(queries.join(' AND '))

    @admin_foragers = Admin::Forager.where(conditions).page(params[:page])
    @admin_foragers_unmigrated =  Admin::Forager.unmigrated.where(conditions).order("updated_at DESC").page(params[:page])
    @admin_foragers_fmigrated =  Admin::Forager.fmigrated.where(conditions).order("updated_at DESC").page(params[:page])
  end

  # GET /admin/foragers/1
  # GET /admin/foragers/1.json
  def show
  end

  # GET /admin/foragers/new
  def new
    @admin_forager = Admin::Forager.new
  end

  # GET /admin/foragers/1/edit
  def edit
  end

  # POST /admin/foragers
  # POST /admin/foragers.json
  def create
    @admin_forager = Admin::Forager.new(admin_forager_params)

    respond_to do |format|
      if @admin_forager.save
        format.html { redirect_to root_path, notice: '文章提交成功.' }
        format.json { render action: 'show', status: :created, location: @admin_forager }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_forager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/foragers/1
  # PATCH/PUT /admin/foragers/1.json
  def update
    @next_forager = Admin::Forager.where(["id > ? AND is_migrated = ?", @admin_forager.id, 'n']).first
    @next_forager ||= Admin::Forager.first

    respond_to do |format|
      if @admin_forager.update(admin_forager_params)
        if admin_page = merge_to_page(@admin_forager)
          format.html { redirect_to edit_admin_forager_path(@next_forager), notice: "采集数据合并成功. <a href='/a-#{admin_page.reload.id}' target='_blank'>预览</a> " }
          format.json { head :no_content }
        else
          format.html { render action: 'edit', notice: '合并失败，请检查.' }
          format.json { render json: @admin_forager.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: 'edit', notice: '合并失败，请检查.' }
        format.json { render json: @admin_forager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/foragers/1
  # DELETE /admin/foragers/1.json
  def destroy
    @next_forager = Admin::Forager.where(["id > ? AND is_migrated = ?", @admin_forager.id, 'n']).first
    @next_forager ||= Admin::Forager.first

    @admin_forager.destroy
    respond_to do |format|
      format.html { redirect_to edit_admin_forager_path(@next_forager), notice: "删除成功！ 进行下一个编辑" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_forager
      @admin_forager = Admin::Forager.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_forager_params
      params.require(:admin_forager).permit(:is_migrated, :is_processed, :source, :author, :title, :content, :tag, :channel, :rant_count, :post_date)
    end

    #copy article from forager to page, then delete it from forager
    def merge_to_page(admin_forager)
      flag = 'f'
      begin
        channel = Admin::Channel.where(title: admin_forager.channel.strip).first
        unless channel.nil?
          page = Admin::Page.find_or_initialize_by(author: admin_forager.author.strip, title: admin_forager.title.strip)
          page.content    = admin_forager.content.gsub(/(\r\n){2,}/, "<br>\n").gsub(/\r\n/, "<br>\n").gsub(/\n/, "<br>\n")
          page.keywords   = admin_forager.tag
          page.short_title = Pinyin.t(page.title).gsub(/[^a-zA-Z0-9-]+/, '-')
          page.user_id    = current_user.id
          page.channel_id = channel.id
          page.save!
          update_tag(page)

          admin_forager.destroy
          flag = 'y'
        end
      rescue => ex
        puts ex.message
      end
      if flag != 'y'
        admin_forager.is_migrated = flag
        admin_forager.save!
      end
      return page
    end

end
