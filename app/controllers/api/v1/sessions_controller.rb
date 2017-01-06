# == Api Session Authentication (log in/ logout)

class Api::V1::SessionsController < Api::ApiController

##
# == Returns a a fresh token to be included in the header for every subsequent api call
#
#   POST https://www..com/api/login
#
# = Params:
#   none
#
# = HTTP Header:
#   X-API-EMAIL     -  Username
#   X-API-PASS			-  Password
#
# = Examples
#
#   1. response = connection.post("/login")
#
#      response.status
#      => 200
#
#      response.body
#      => {"id":1,
#          "auth_token":"ixVi5dfknS2ndfnad9"}
#
#   2. response = connection.post("/login")
#
#      response.status
#      => 401
#
#      response.body
#      => {"message": "unauthorized"}
#
#   3. response = connection.post("/login")
#
#      response.status
#      => 422
#
#      response.body
#      => {"errors":"Invalid email or password"}
##

	def create
		user_email = request.headers['X-API-EMAIL'].presence
		user_password = request.headers['X-API-PASS'].presence
		user_device_token = request.headers['X-API-DEVICE-TOKEN'].presence
		user_device_type = request.headers['X-API-DEVICE-TYPE'].presence

		user = user_email.present? && User.find_by_email(user_email)
		if user
			if user.valid_password?(user_password)
				sign_in user, store: false
				user.device_token = user_device_token
				user.device_type = user_device_type
				user.generate_auth_token
				user.save

				render json: {user: user}, :status => :created
			else
				render json: {errors: "Invalid email or password"}, status: 422
			end
		else
			render json: {errors: "User not found"}, status: 422
		end
	end

##
# == Resets users current api authentication_token. Does not return the new token.
#
#   DELETE https://www..com/api/logout
#
# = Params:
#   none
#
# = HTTP Header:
#   Authorization     -  auth_token
#
# = Examples
#
#   1. response = connection.delete("/logout)
#
#      response.status
#      => 204
#
#      response.body
#      => {"message":"Session Ended"}
#
#   2. response = connection.delete("/logout")
#
#      response.status
#      => 404
#
#      response.body
#      => {"message": "Invalid Token"}
##

	def destroy
		respond_to do |format|
			format.html{
				super
			}
			format.json{
				user = User.find_by_auth_token(request.headers['Authorization'])
				if user
					user.generate_auth_token
					user.save
					render :json => {:message => 'Session Ended'}, :success => true, :status => 204
				else
					render :json => {:message => 'Invalid Token'}, :status => 404
				end
			}
		end
	end

	def invalid_login_attempt
		warden.custom_failure!
		render :json => {:errors => ["Invalid email or password"]}, :success => false, :status => :unauthorized
	end
end
