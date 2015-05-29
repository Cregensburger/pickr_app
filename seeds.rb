require_relative 'users.rb'
require 'pry'


#add a test user to our database 
user = User.new({ :user_name => "Redman", :email => "redman@email.com", :password => "red"})
user.hash_password
user.save

user1 = User.new({ :user_name => "Blueman", :email => "blueman@email.com", :password => "blue"})
user.hash_password