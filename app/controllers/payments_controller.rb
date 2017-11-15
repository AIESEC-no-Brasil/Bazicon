class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:customer_name, :local_committee,
      :application_id, :program, :opportunity_name, :value)
  end
end
