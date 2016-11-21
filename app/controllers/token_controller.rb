class TokenController < ApplicationController
	before_filter :cors_preflight_check
	after_filter :cors_set_access_control_headers

	def get_analytics_token
		puts Thread.current.object_id
		if EXPA.client.nil?
			xp = EXPA.setup()
			xp.auth(ENV['SIMPLE_TOKEN_EMAIL'],ENV['SIMPLE_TOKEN_PASSWORD'])
			response.headers['Access-Control-Allow-Credentials'] = 'true'
			response.headers['Access-Control-Allow-Origin'] = '*'
			response.headers['Access-Control-Max-Age'] = '1728000'
			puts EXPA.client.get_email
			render :json => {:token => xp.get_updated_token.to_s}
		else
			response.headers['Access-Control-Allow-Credentials'] = 'true'
			response.headers['Access-Control-Allow-Origin'] = '*'
			response.headers['Access-Control-Max-Age'] = '1728000'
			puts EXPA.client.get_email
			render :json => {:token => EXPA.client.get_updated_token.to_s}
		end
	end

	def auth
    	email = params['email']
    	password = params['password']
    	unless email.nil? or password.nil?
		 	EXPA.setup() if EXPA.client.nil?
			render :json => EXPA.client.login(email,password)
    	else
    		render 403
    	end
	end

	def cors_preflight_check
	  if request.method == 'OPTIONS'
	    headers['Access-Control-Allow-Origin'] = '*'
	    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
	    headers['Access-Control-Allow-Headers'] = 'X-Requested-With,Content-Type, X-Prototype-Version, Token'
	    headers['Access-Control-Max-Age'] = '1728000'

	    render :plain => '', :content_type => 'text/plain'
	  end
	end

	def cors_set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
		headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
		headers['Access-Control-Max-Age'] = "1728000"
	end
end