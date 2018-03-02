class PaymentsController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  helper_method :sort_column, :sort_direction

  expose :user, -> { current_user }
  expose :local_committee, -> { user.local_committee }
  expose :payment, find_by: :slug
  expose(:payments) { Payment.where(local_committee: local_committee).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 25) }

  def new
    redirect_to root_path unless can?(:manage, payment)
    self.payment.local_committee = local_committee
  end

  def create
    # FIX-ME this nonsense logic
    payment.value = payment_params[:value].tr('^0-9', '')
    self.payment.local_committee = local_committee

    if can?(:manage, payment) && payment.save
      redirect_to payment_path(payment, created: true), notice: 'Pagamento registrado com sucesso!'
    else
      flash.now[:error] = 'Erro ao registrar o pagamento.'
      render :new
    end
  end

  def index
    redirect_to root_path unless can?(:manage, payment)
  end

  def show
  end

  def destroy
    payment.pagarme_transactions.last.created? && payment.destroy
    redirect_to action: :index
  end

  private

  def sort_column
    Payment.column_names.include?(params[:sort]) ? params[:sort] : "customer_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def payment_params
    params.require(:payment)
      .permit(:customer_name, :customer_email, :local_committee, :status,
      :application_id, :program, :opportunity_name, :value, :tag)
  end
end
