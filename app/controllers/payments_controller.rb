class PaymentsController < ApplicationController
  before_action :authenticate_user!

  expose :user, -> { current_user }
  expose :local_committee, -> { user.local_committee }
  expose :payment
  expose(:payments) { Payment.where(local_committee: local_committee) }

  def new
    self.payment.local_committee = User.local_committees[local_committee]
  end

  def create
    if payment.save
      redirect_to payment_path(payment)
    else
      render :new
    end
  end

  def index
  end

  def show
  end

  private

  def payment_params
    params.require(:payment)
    .permit(:customer_name, :local_committee, :status,
      :application_id, :program, :opportunity_name, :value, :tag)
  end
end
