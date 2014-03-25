class CommentsController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]
  before_action :set_channel, only: [:new, :create]
  layout 'frontpage'

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to "/", notice: '留言成功.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use for frontpage layout.
    def set_channel
      @channel = Admin::Channel.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:name, :mobile_phone, :tel_phone, :email, :qq, :address, :gender, :birth, :hobby, :content, :content2, :content3, :status)
    end
end
