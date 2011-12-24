class ChannelsController < ApplicationController

  # Para el calculo del token de canal
  require 'digest/md5'
  # Libreria para paginado
  require 'will_paginate'

  before_filter :own_channel, :only => [:show_xml, :edit, :update, :live_player]
  before_filter :reset_token_channel, :only => [:show_xml, :live_player]
  before_filter :listado_inicial_videos, :only => [:show, :listado_videos]

  def new  
    @channel = Channel.new  
  end  

  def show
    if @channel
      # Incrementa el contador de visitas si no es el propio usuario
      if current_channel != @channel
        @channel.views += 1
        @channel.save
      end
      # Saca los datos de video online
      condiciones_live = "live" + ( current_channel != @channel ? " AND public" : "" )
      @video_live = @channel.videos.first( :conditions => condiciones_live )
    else
      redirect_to(:controller => :home)
    end
  end

  def mas_videos
    channel = Channel.find_by_id(params[:id])
    condiciones = "NOT live" + ( current_channel != @channel ? " AND public" : "" )
    @videos = channel.videos.paginate( :order => 'created_at DESC', :conditions => condiciones, :page => params[:page], :per_page => 3 )
    render :update do |page|
      page.replace 'mas_videos', :partial => 'videos', :locals => { :id => params[:id] }
    end
  end

  def listado_videos
    render :update do |page|
      page.replace 'caja_videos', :partial => 'listado_videos', :locals => { :id => params[:id] }
    end
  end

  def show_xml
    #@channel.stream_token = Digest::MD5.hexdigest(Time.now.to_s)
    #@channel.save
    stream = render_to_string :file=>"channels/flashmediaencoder.rhtml"
    send_data(stream, :type=>"text/xml",:filename => "webstream.xml")  
  end

  def create  
    @channel = Channel.new(params[:channel])  
    if @channel.save_without_session_maintenance
      @channel.deliver_activation_instructions!
      flash[:notice] = "El canal se ha creado. Recibirá por mail las instrucciones para activarlo"
      redirect_to root_url
    else
      render :action => :new
    end
  end 

  def edit  
  end  

  def editar
    @channel = current_channel
    if @channel
      render :update do |page|
        page.replace_html params[:update], :partial => 'channel'
      end
    end
  end
      
  def update  
    if @channel.update_attributes(params[:channel])  
      flash[:notice] = "Successfully updated profile."  
      redirect_to :controller => :home
   else  
     render :action => 'edit'  
   end  
 end  

 def live_player 
   if @channel
     render :update do |page|
       page.replace 'caja_videos', :partial => 'live_player'
     end
   else
     redirect_to :controller => :home
   end    
 end

 # Comprueba si en el canal se ha empezado a emitir en directo 
 def check_live
   channel = Channel.find_by_id(params[:id])
   video = channel.videos.find_by_live(true) if channel
   render :update do |page|
     # Si se esta emitiendo y la pagina no lo sabe
     if video && params[:live] && params[:live] == "false"
       # Mete el video en directo
       page.replace_html 'video_live', :partial => 'videos/video_embebido_live', :locals => { :video => video }
       # Cambia el valor del status por el id del video
       page.replace_html 'video_live_status', :inline => video.id.to_s
     # Si ya no se esta emitiendo y la pagina no lo sabe
     elsif video.nil? && params[:live] && params[:live] != "false"
       # Pone un mensajito para que se sepa que ha parado
       page.replace_html 'video_live', :inline => "<div class='resaltado'>Ha terminado el directo del Canal</div>" 
       # Cambia el estado a false
       page.replace_html 'video_live_status', :inline => 'false'
       # Mete el video que ha dejado de emitir en el listado de enlatados
       video = Video.find_by_id(params[:live])
       page.replace('nuevo_video_vod', :partial => 'videos/nuevo_video_vod', :locals => { :video => video }) if video
     # En otro caso le mantenemos el valor anterior 
     else
       page.replace_html 'video_live_status', :inline => (params[:live] || "false") 
     end
   end
 end

 private
   def own_channel
     @channel = current_channel
     redirect_to(:controller => :home) unless @channel
   end

   def listado_inicial_videos
    @channel = Channel.find_by_name(params[:id])
    if @channel
      # Saca los datos de videos emitidos
      condiciones = "NOT live" + ( current_channel != @channel ? " AND public" : "" )
      @videos = @channel.videos.paginate( :order => 'created_at DESC', :conditions => condiciones, :page => 1, :per_page => 3 )
    end
   end

   def reset_token_channel
     if @channel
       @channel.stream_token = Digest::MD5.hexdigest(Time.now.to_s)
       @channel.save
     end
   end

end
