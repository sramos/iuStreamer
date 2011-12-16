class HomeController < ApplicationController

  def index
    condiciones = ""
    condiciones = "active = true" unless current_channel && current_channel.admin
    @channels = Channel.all(:conditions => {:active => true})
  end

  def login
    render :update do |page|
      page.replace_html 'inicio_derecha', :partial => 'login'
    end
  end

  def reset_pass
    render :update do |page|
      page.replace_html 'inicio_derecha', :partial => 'reset_pass'
    end
  end

end
