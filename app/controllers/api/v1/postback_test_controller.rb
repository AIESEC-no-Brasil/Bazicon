class Api::V1::PostbackTestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def status_update
    render json: { params: params }
  end
end
