class Api::V1::ExpaPersonController < ApplicationController
	def validate_email
		if ExpaPerson.find_by(xp_email: params[:email])
      render json: { email_exists: true }
    else
      render json: { email_exists: false, params: params[:email] }
    end
	end
end
