module Api
  module V1
    module Pagarme
      class PostbackController < ApplicationController
        require 'pagarme'
        
        skip_before_action :verify_authenticity_token

        def update_status
          if valid_postback?
            # Handle your code here
            # postback payload is in params
            puts "params ======================== "
            puts params
            puts "payment_id #{params[:payment_id]}"
            puts params[:current_status]
            puts params[:event]
            puts params[:fingerprint]
          else
            render_invalid_postback_response
          end

          render json: { params: params }
        end

        protected
        
        def valid_postback?
          raw_post  = request.raw_post
          signature = request.headers['HTTP_X_HUB_SIGNATURE']
          PagarMe::Postback.valid_request_signature?(raw_post, signature)
        end
        
        def render_invalid_postback_response
          render json: {error: 'invalid postback'}, status: 400
        end
      end
    end
  end
end
