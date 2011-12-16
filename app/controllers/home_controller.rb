class HomeController < ApplicationController

  def index
    @channels = Channel.all(:conditions => {:active => true})
  end

  def login
    render :update do |page|
      page.replace_html 'inicio_derecha', :partial => 'login'
    end
  end

  def register
    @channel = Channel.new
    render :update do |page|
      page.replace_html 'inicio_derecha', :partial => 'register'
    end
  end

  def reset_pass
    render :update do |page|
      page.replace_html 'inicio_derecha', :partial => 'reset_pass'
    end
  end

end
