class TokenController < ApplicationController
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
end