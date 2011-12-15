class HomeController < ApplicationController

  def index
    @channels = Channel.all
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

end
