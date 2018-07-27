class User < ActiveRecord::Base
  has_many :sounds
  validates_presence_of :username, :password
  has_secure_password



end
