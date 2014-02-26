class Admin::CommentsController < Admin::ApplicationController
  before_action :set_admin_comment, only: [:show, :edit, :update, :destroy]
 
  # GET /admin/comments
  # GET /admin/comments.json
  def index
    @comments = Admin::Comment.order("updated_at DESC").page(params[:page])
  end

  # GET /admin/comments/1
  # GET /admin/comments/1.json
  def show
  end

  # GET /admin/comments/new
  def new
    @comment = Admin::Comment.new
  end

  # GET /admin/comments/1/edit
  def edit
  end

  # POST /admin/comments
  # POST /admin/comments.json
  def create
    @comment = Admin::Comment.new(admin_comment_params)

    respond_to do |format|
      if @admin_comment.save
        format.html { redirect_to admin_comments_path, notice: '添加成功.' }
        format.json { render action: 'show', status: :created, location: @admin_comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/comments/1
  # PATCH/PUT /admin/comments/1.json
  def update
    #only user can modify 
    unless current_user.has_role?(:admin) || current_user.has_role?(:user)
      redirect_to admin_comments_path, alert: "没有修改权限"
      return
    end
    respond_to do |format|
      if @comment.update(admin_comment_params)
        format.html { redirect_to admin_comments_path, notice: '修改成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/comments/1
  # DELETE /admin/comments/1.json
  def destroy
    #only user can modify 
    unless current_user.has_role?(:admin) || current_user.has_role?(:user)
      redirect_to admin_comments_path, alert: "没有修改权限"
      return
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to admin_comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_comment
      @comment = Admin::Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_comment_params
      params.require(:admin_comment).permit(:name, :mobile_phone, :tel_phone, :email, :qq, :address, :gender, :birth, :hobby, :content, :content2, :content3, :status)
    end
end
