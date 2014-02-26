class Admin::KeystoresController < Admin::ApplicationController
  before_action :set_admin_keystore, only: [:show, :edit, :update, :destroy]
  
  # GET /admin/keystores
  # GET /admin/keystores.json
  def index
    @admin_keystores = Admin::Keystore.page(params[:page])
  end

  # GET /admin/keystores/1
  # GET /admin/keystores/1.json
  def show
  end

  # GET /admin/keystores/new
  def new
    @admin_keystore = Admin::Keystore.new
  end

  # GET /admin/keystores/1/edit
  def edit
  end

  # POST /admin/keystores
  # POST /admin/keystores.json
  def create
    @admin_keystore = Admin::Keystore.new(admin_keystore_params)

    respond_to do |format|
      if @admin_keystore.save
        format.html { redirect_to admin_keystores_path, notice: '参数添加成功.' }
        format.json { render action: 'show', status: :created, location: @admin_keystore }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_keystore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/keystores/1
  # PATCH/PUT /admin/keystores/1.json
  def update
    respond_to do |format|
      if @admin_keystore.update(admin_keystore_params)
        format.html { redirect_to admin_keystores_path, notice: '参数更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_keystore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/keystores/1
  # DELETE /admin/keystores/1.json
  def destroy
    #only admin can modify 
    unless current_user.has_role?(:admin) 
      redirect_to admin_keystores_path, alert: "没有权限"
      return
    end
    @admin_keystore.destroy
    respond_to do |format|
      format.html { redirect_to admin_keystores_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_keystore
      @admin_keystore = Admin::Keystore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_keystore_params
      params.require(:admin_keystore).permit(:key, :value, :description)
    end
end
