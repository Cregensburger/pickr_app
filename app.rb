require 'sinatra'
require 'sinatra/reloader'

# Include the user model 
#require_relative './user'

# Sessions are turned off by default, so enable it here
# We use sessions in our app to keep track of authenticated users. If we didn't 
# use sessions, the same user would have to log back in with every request to 
# a new page
enable :sessions

# Filter that runs before all routes are processed
# This is run first, then the code within the routes below
before do 
	# If they have a session id, we know it's someone who has successfully authenticated
	if session[:user_id] != nil
		# If there's a user with an active session, go ahead and get the data for the user
		@current_user = User.find(session[:user_id])
	else 
		# We don't know who this is yet
		@current_user = nil
	end
end 

# Guest Homepage route
get '/' do
	erb :guest_home
	#erb :login
	#erb :register
end

# User Homepage route
get '/user/homepage' do
	erb :index
	erb :logout
end

# # Display login form
# get '/login' do 
# 	erb :login
# end

# # Display registration form
# get '/register' do
# 	erb :register
# end

# Check if login form contents posted is valid
post '/' do 
	# Get form params
	user_name = params['user_name']
	password = params['password']

	# Get an instance of the user with this username 
	user = User.find_by(:user_name => user_name)

	# If a user by this user_name was found and we can authenticate them
	if user && user.authenticate(password)
		# This is a valid user in our database
		# Keep track of the user by setting a session variable called 'user_id'
		session[:user_id] = user.id
		redirect('/users/homepage')
	
	#If user is a new user, redirect to register page
	#elsif 

	else 
		# Not a valid user
		redirect('/')
	end
end 

# Process registration data and add the new user
post '/' do 
	# Create an instance of a user with the new data posted
	user = User.new(:user_name => params[:user_name], :email => params[:email], :password => params[:password])
	user.hash_password
	user.save

	# We need to set a session variable or they will have to log in when going to the index page, which 
	# looks like a bug
	session[:user_id] = user.id

	# For our purposes, they are now authorized to see our protected content
	redirect('/user/homepage')
end


# Display the current user 
get '/user/:id' do 
	erb :profile
end