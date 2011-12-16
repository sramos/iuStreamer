class VideosController < ApplicationController

  def show
    @video = Video.find_by_filename(params[:code])
    redirect_to :controller => :home unless @video
  end

  def show_live
    channel = Channel.find_by_name(params[:channel])
    @video = Video.find_by_live(true)
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
    render :update do |page|
      page.replace 'caja_videos', :partial => 'ver_video'
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
