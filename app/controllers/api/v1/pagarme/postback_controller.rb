module Api
  module V1
    module Pagarme
      class PostbackController < ApplicationController
        def update_status
          payment = Payment.find_by (id: params[:id])
        end
      end
    end
  end
end
