class WelcomeController < ApplicationController
  caches_page :index 
  
  layout 'frontpage'

  #{"controller"=>"welcome", "action"=>"index", "channel"=>"fw", "id"=>"2", "tag" => "tagkey"}
  #params
  # :channel => channel.short_title
  # :id      => page.id
  # :tag     => tag
  #rules:
  # 1. a URL query must has channel except root
  # 2. If has page, the channel is page.channel, not care the params
  def index
    #render text: request.path and return
   
    #page first, then channel ?
    if params[:id]
      @page = Admin::Page.find_by(id: params[:id])
    end
    @channel = @page.channel if @page

    #short_title use for frontpage cache
    @channel ||= Admin::Channel.find_by(short_title: params[:channel])
    #channel id is not cached, use to previous
    @channel ||= Admin::Channel.find_by(id: params[:channel])

    #root index.html has no params
    if params.delete_if {|k, v| ['controller', 'action'].include?(k)}.empty?
      @channel ||= Admin::Channel.first 
    end
    
    not_found if @channel.nil?
    not_found if params[:id] && @page.nil?
    
    if params[:search]
      @pages = Admin::Page.search(params[:search]).order("updated_at DESC").page(params[:page])
    #tag
    elsif params[:tag]
      @pages = Admin::Page.tagged_with(params[:tag]).order("updated_at DESC").page(params[:page])
    else
      #@pages = @channel.pages.order("updated_at DESC").page(params[:page])
      @pages = Admin::Page.joins(:channel).where(["admin_channels.id = ? OR admin_channels.parent_id = ?", @channel.id, @channel.id]).order("admin_pages.updated_at DESC").page(params[:page])  
    end
    #tag cloud
    @tags = Admin::Page.tag_counts_on(:tags)

    #comment
    @comment = Comment.new
    
    #统一访问路径，使URL呈唯一性
    if @page
      if request.path != "/#{@channel.short_title}/#{@page.id}"
        redirect_to "/#{@channel.short_title}/#{@page.id}"
      end
    end

  end

  def search
    @pages = Admin::Page.search(params[:search]).order("updated_at DESC").page(params[:page])
    @channel ||= Admin::Channel.first 

    #comment
    @comment = Comment.new
  end

  def tag
    @pages = Admin::Page.tagged_with(params[:tag]).order("updated_at DESC").page(params[:page])
    @channel ||= Admin::Channel.first

    #comment
    @comment = Comment.new
  end

end
