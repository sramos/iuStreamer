class VideosController < ApplicationController

  def show
    @video = Video.find_by_id(params[:id])
    redirect_to :controller => :home unless @video && current_channel == @video.channel
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
