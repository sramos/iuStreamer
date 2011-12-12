# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_channel

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private  
  def current_channel_session  
    return @current_channel_session if defined?(@current_channel_session)  
    @current_channel_session = ChannelSession.find  
  end  
      
  def current_channel  
   @current_channel = current_channel_session && current_channel_session.record  
  end  
end
