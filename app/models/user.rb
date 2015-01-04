class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  #this is the same as above. method and hash as last argument drops all that ({})
  #validates(:name, {presence: true}) 
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #This allows example@gmail..com, which is wrong
  validates :email, presence: true, length: { maximum: 255 }, 
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
            
  has_secure_password
  validates :password, length: { minimum: 6 }
  
end
