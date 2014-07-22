class User < ActiveRecord::Base

  attr_accessor :phone

  validates :phone, presence: true, uniqueness: true
end
