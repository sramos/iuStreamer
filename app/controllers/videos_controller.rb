class VideosController < ApplicationController

  def show
    @video = Video.find_by_id(params[:id])
    redirect_to :controller => :home unless @video && current_channel == @video.channel
  end

end
