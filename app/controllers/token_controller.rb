class TokenController < ApplicationController
	def get_analytics_token
		if EXPA.client.nil?
			xp = EXPA.setup()
			xp.auth(ENV['SIMPLE_TOKEN_EMAIL'],ENV['SIMPLE_TOKEN_PASSWORD'])
			puts 'here'
			render :json => xp.get_updated_token
		else
			puts 'Not nil'
			render :json => EXPA.client.get_updated_token
		end
	end
end