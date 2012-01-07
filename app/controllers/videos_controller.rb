class VideosController < ApplicationController

  def show
    @video = Video.find_by_filename params[:code]
    # Esto lo hacemos para que cuente el que esta pidiendo el video
    @video.views += 1 if @video
    redirect_to :controller => :home unless @video
  end

  def show_live
    channel = Channel.find_by_name(params[:channel])
    @video = channel.video.find_by_live(true) if channel
    redirect_to :controller => :home unless @video
    render :show if @video
  end

  def cambia_publico
    video = Video.find_by_id(params[:id])
    video.public = params[:public]
    video.save
    render :update do |page|
      page.replace params[:update], :partial => 'video', :locals => {:video => video}
    end
  end

  def ver_video
    @video = Video.find_by_id(params[:id])
    # Esto lo hacemos para que cuente el que esta pidiendo el video
    @video.views += 1 if @video
    render :update do |page|
      page.replace 'caja_videos', :partial => 'ver_video'
    end
  end

  def download
    video = Video.find_by_id(params[:id], :conditions => {:live => false})
    if video && File.exists?(ENV['VIDEO_BASE_PATH'] + "/" + video.filename + ".flv")
      send_file ENV['VIDEO_BASE_PATH'] + "/" + video.filename + ".flv",
             :disposition => 'attachment',
             :type => "application/video/x-flv"
    else
      redirect_to channel_url(video.channel.name) if video
      redirect_to :controller => :home unless video
    end
  end

  def thumbnail
    video = Video.find_by_id(params[:id])
    if video && File.exists?(ENV['VIDEO_BASE_PATH'] + "/" + video.filename + ".flv.png")
      send_file ENV['VIDEO_BASE_PATH'] + "/" + video.filename + ".flv.png",
             :disposition => 'attachment',
             :type => "image/png"
    else
      send_file Rails.root.join("public","images","colour-bars.png"),
             :disposition => 'attachment',
             :type => "image/png"
    end
  end

  def delete
    video = Video.find_by_id(params[:id])
    video.delete
    # Borra fisicamente el video
    Dir.glob(File.join(ENV['VIDEO_BASE_PATH'] + "/" + video.filename + "*")).each do |file|
      File.delete(file)
    end if File.exists?( ENV['VIDEO_BASE_PATH'] + "/" + video.filename + ".flv" )
    render :update do |page|
      page.replace params[:update], :inline => ''
    end     
  end

end
