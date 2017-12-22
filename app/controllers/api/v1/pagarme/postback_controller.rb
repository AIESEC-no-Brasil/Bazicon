module Api
  module V1
    module Pagarme
      class PostbackController < ApplicationController
        require 'pagarme'
        skip_before_action :verify_authenticity_token
        PagarMe.api_key = ENV['PAGARME_API_KEY']

        def update_status
          if valid_postback?
            payment = Payment.find_by(id: params[:payment_id])
            payment.update(pagarme_id: params[:id]) unless payment.pagarme_id

            if params[:event] == "transaction_status_changed"
              payment.update(status: params[:current_status])

              if params[:current_status] == "authorized"
                CaptureTransaction.call(params[:payment_id])
              end
            end
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
