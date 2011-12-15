class PasswordResetsController < ApplicationController  

  before_filter :require_no_channel
  before_filter :load_channel_using_perishable_token, :only => [:edit, :update]

  def new  
  end  
  
  def create  
    @channel = Channel.find_by_email(params[:email])  
    if @channel
      @channel.deliver_password_reset_instructions!  
      flash[:notice] = "Se han enviado por mail las instrucciones de cambio de clave"  
      redirect_to :controller => :home
    else  
      flash[:notice] = "No se encontró un Canal con ese mail"  
      redirect_to :controller => :home
    end  
  end

  def edit  
  end  
  
  def update  
    @channel.password = params[:channel][:password]  
    @channel.password_confirmation = params[:channel][:password_confirmation]  
    if @channel.save  
      flash[:notice] = "Password cambiada"  
      redirect_to :controller => :home  
    else  
      render :action => :edit
    end  
  end  
  
  private  
    def load_channel_using_perishable_token  
      @channel = Channel.find_using_perishable_token(params[:id])  
      unless @channel  
        flash[:notice] = "Ha sido imposible localizar el Canal"  
        redirect_to :controller => :home  
      end  
    end  

    def require_no_channel
      redirect_to :controller => :home if current_channel
    end

end  
