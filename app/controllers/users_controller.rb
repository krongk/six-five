class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => '没有管理员权限.'
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => '没有管理员权限.'
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to users_path, :notice => "修改成功."
    else
      redirect_to users_path, :alert => "无法修改."
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => '没有管理员权限.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "删除成功."
    else
      redirect_to users_path, :notice => "不能删除你自己."
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :salt, :encrypted_password, :password_confirmation, :role_ids)
  end
end