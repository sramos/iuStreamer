class Channel < ActiveRecord::Base
  acts_as_authentic do |configuration| 
    configuration.login_field = :name
  end

  #attr_accessible :login, :email, :password, :password_confirmation

  has_many :videos

  validates_presence_of :name, :email, :crypted_password

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end 

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_welcome!
    reset_perishable_token!
    Notifier.deliver_welcome(self)
  end

  def activate!
    self.active = true
    save
  end

end
