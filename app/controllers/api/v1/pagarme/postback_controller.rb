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

            if params[:event] == "transaction_status_changed"
              if PagarmeTransaction.find(pagarme_id: params[:id])
                PagarmeTransaction.find(pagarme_id: params[:id]).update(status: params[:current_status])
              else
                PagarMeTransaction.create(pagarme_id: params[:id], payment_id: payment.id, status: params[:current_status])
              end

              payment.update(status: params[:current_status])

              if params[:current_status] == "authorized"
                payment.update(payment_method: params[:transaction][:payment_method]) unless payment.payment_method
                CaptureTransaction.call(params[:payment_id])
              end

              if params[:transaction][:payment_method] == "boleto"
                payment.update(boleto_url: params[:transaction][:boleto_url])
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
