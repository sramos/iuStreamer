class Channel < ActiveRecord::Base
  acts_as_authentic do |configuration| 
    configuration.login_field = :name
  end

  has_many :videos

  validates_presence_of :name, :email, :crypted_password

end
