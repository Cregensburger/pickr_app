require 'active_record'
require 'bcrypt'

# Establish a database connection 
ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:host => 'localhost',
	:database => 'pickr'
)

# User Class
class User < ActiveRecord::Base
	# Add a attr_accessor for password so that it's part of the model even though 
	# it's not in the database. If we don't do this, then we will get an error trying
	# to access :password within the user instance
	attr_accessor :password

	# Take a plain text password and authenticate it against the hashed password in the database
	def authenticate(password)
		# If the hashed version of the password matches what's in the database, it's valid
		if BCrypt::Password.new(self.password_digest) == password
			return true
		else 
			return false
		end
	end

	# Hash the current user's password using bcrypt and set it to 'password_digest' in the model
	def hash_password
		# Is there a password set in the model? If not then do nothing
		if password.present?
			return self.password_digest = BCrypt::Password.create(password)
		end
	end

end