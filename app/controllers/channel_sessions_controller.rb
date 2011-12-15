class ChannelSessionsController < ApplicationController

 def new  
 end  
 
 def create  
   @channel_session = ChannelSession.new(params[:channel_session])  
   if @channel_session.save  
     flash[:notice] = "Successfully logged in."
     #@user_session.user.reset_persistence_token!
     #@user_session.save
     redirect_to :controller => :home
   else
     flash[:notice] = @channel_session.errors.first[1]
     puts "----------------> " + @channel_sessions.errors.to_s if @channel_sessions && @channel_sessions.errors
     render :action => 'new'  
   end  
 end 
 
 def destroy  
   @channel_session = ChannelSession.find  
   @channel_session.destroy  
   flash[:notice] = "Successfully logged out."  
   redirect_to :controller => :home
 end 

end

