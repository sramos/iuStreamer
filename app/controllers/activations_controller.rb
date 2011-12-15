class ActivationsController < ApplicationController
  before_filter :require_no_channel

  def create
    @channel = Channel.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @channel.active?

    if @channel.activate!
      flash[:notice] = "El canal se ha activado!"
      ChannelSession.create(@channel, false) # Log user in manually
      @channel.deliver_welcome!
      redirect_to :controller => :channels, :action => :show, :id => @channel.name 
    else
      render :action => :new
    end
  end

  private

    def require_no_channel
      redirect_to :controller => :home if current_channel
    end
end
