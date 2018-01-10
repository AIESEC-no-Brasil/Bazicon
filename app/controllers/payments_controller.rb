class PaymentsController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]

  expose :user, -> { current_user }
  expose :local_committee, -> { user.local_committee }
  expose :payment
  expose(:payments) { Payment.where(local_committee: local_committee) }

  def new
    redirect_to root_path unless can?(:manage, payment)
    self.payment.local_committee = User.local_committees[local_committee]
  end

  def create
    if can?(:manage, payment) && payment.save
      redirect_to payment_path(payment), notice: 'Pagamento registrado com sucesso!'
    else
      flash[:error] = 'Erro ao registrar o pagamento.'
      render :new
    end
  end

  def index
    redirect_to root_path unless can?(:manage, payment)
  end

  def show
  end

  def destroy
    payment.created? && payment.destroy
    redirect_to action: :index
  end

  private

  def payment_params
    params.require(:payment)
      .permit(:customer_name, :local_committee, :status,
      :application_id, :program, :opportunity_name, :value, :tag)
  end
end
