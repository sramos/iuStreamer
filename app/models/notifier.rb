class Notifier < ActionMailer::Base  

  default_url_options[:host] = ENV['RTMP_HOST']  
  
  def password_reset_instructions(channel)
    subject       "Password Reset Instructions"  
    from          "noreply@" + ENV['RTMP_HOST']
    recipients    channel.email
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(channel.perishable_token)  
  end  

  def activation_instructions(channel)
    subject       "Activation Instructions"
    from          "noreply@" + ENV['RTMP_HOST'] # Removed name/brackets around 'from' to resolve "555 5.5.2 Syntax error." as of Rails 2.3.3
    recipients    channel.email
    sent_on       Time.now
    body          :account_activation_url => activate_url(channel.perishable_token)
  end

  def welcome(channel)
    subject       "Welcome to the site!"
    from          "noreply@" + ENV['RTMP_HOST']
    recipients    channel.email
    sent_on       Time.now
    body          :root_url => root_url
  end
end 
