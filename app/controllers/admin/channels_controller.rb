class Admin::ChannelsController < Admin::ApplicationController
  before_action :set_admin_channel, only: [:show, :edit, :update, :destroy]

  # GET /admin/channels
  # GET /admin/channels.json
  def index
    @admin_channels = Admin::Channel.where("parent_id IS NULL OR parent_id = 0").page(params[:page])
  end

  # GET /admin/channels/1
  # GET /admin/channels/1.json
  def show
    @pages = @admin_channel.pages.order('updated_at DESC').page(params[:page])
  end

  # GET /admin/channels/new
  def new
    @admin_channel = Admin::Channel.new
  end

  # GET /admin/channels/1/edit
  def edit
  end

  # POST /admin/channels
  # POST /admin/channels.json
  def create
    @admin_channel = Admin::Channel.new(admin_channel_params)
    @admin_channel.user_id = current_user.id
    @admin_channel.short_title = get_short_title('channel', @admin_channel.title) if @admin_channel.short_title.blank?

    respond_to do |format|
      if @admin_channel.save
        update_tag(@admin_channel)
        format.html { redirect_to @admin_channel, notice: '栏目添加成功.' }
        format.json { render action: 'show', status: :created, location: @admin_channel }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/channels/1
  # PATCH/PUT /admin/channels/1.json
  def update
    #only user can modify 
    unless current_user.has_role?(:admin) || current_user.has_role?(:user)
      redirect_to admin_channels_path, alert: "没有权限"
      return
    end

    admin_channel_params[:user_id] = current_user.id

    respond_to do |format|
      if @admin_channel.update(admin_channel_params)
        update_tag(@admin_channel)
        if @admin_channel.short_title.blank?
          @admin_channel.short_title = get_short_title('channel', @admin_channel.title)
          @admin_channel.save!
        end

        format.html { redirect_to @admin_channel, notice: '栏目更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/channels/1
  # DELETE /admin/channels/1.json
  def destroy
    #only user can modify 
    unless current_user.has_role?(:admin) || current_user.has_role?(:user)
      redirect_to admin_channels_path, alert: "没有权限"
      return
    end
    @admin_channel.destroy
    respond_to do |format|
      format.html { redirect_to admin_channels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_channel
      @admin_channel = Admin::Channel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_channel_params
      params.require(:admin_channel).permit(:user_id, :parent_id, :typo, :title, :short_title, :properties, :default_url, :tmp_index, :tmp_list, :tmp_detail, :keywords, :description, :content)
    end
end
