class ChannelsController < ApplicationController

  require 'digest/md5'
  # Libreria para paginado
  require 'will_paginate'

  before_filter :own_channel, :only => [:show_xml, :edit, :update]

  def new  
    @channel = Channel.new  
  end  

  def show
    @channel = Channel.find_by_name(params[:id])
    if @channel
      # Incrementa el contador de visitas
      @channel.views += 1
      @channel.save
      # Saca los datos de video online y videos emitidos
      condiciones = ["NOT live"]
      if current_channel != @channel
        puts "------------> Queremos mirar solo los publicos"
        condiciones += ["public"]
      end
      @video_live = @channel.videos.first( :conditions => { :live => true })
      @videos = @channel.videos.paginate( :order => 'created_at DESC', :conditions => condiciones, :page => 1, :per_page => 3 )
    else
      redirect_to(:controller => :home)
    end
  end

  def mas_videos
    channel = Channel.find_by_id(params[:id])
    condiciones = ["NOT live"]
    if current_channel != channel
        puts "------------> Queremos mirar solo los publicos"
      condiciones += ["public"]
    end
    @videos = channel.videos.paginate( :order => 'created_at DESC', :conditions => condiciones, :page => params[:page], :per_page => 3 )
    render :update do |page|
      page.replace 'mas_videos', :partial => 'videos', :locals => { :id => params[:id] }
    end
  end

  def show_xml
    @channel.stream_token = Digest::MD5.hexdigest(Time.now.to_s)
    @channel.save
    stream = render_to_string :file=>"channels/flashmediaencoder.rhtml"
    send_data(stream, :type=>"text/xml",:filename => "webstream.xml")  
  end

  def create  
    @channel = Channel.new(params[:channel])  
    if @channel.save  
      flash[:notice] = "Registration successful."  
      redirect_to :controller => :home
    else  
      render :action => 'new'  
    end  
  end 

  def edit  
  end  
      
  def update  
    if @channel.update_attributes(params[:channel])  
      flash[:notice] = "Successfully updated profile."  
      redirect_to :controller => :home
   else  
     render :action => 'edit'  
   end  
 end  

 private
   def own_channel
     @channel = current_channel
     redirect_to(:controller => :home) unless @channel
   end

end
