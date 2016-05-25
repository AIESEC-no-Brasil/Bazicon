class FormsController < ApplicationController

  def show_feedback_form


  end

  def send_feedback

    @email = params[:email]
    @name = params[:name]
    @topic = params[:topic]
    @description = params[:description]
    FeedbackForm.send_feedback(@email,@name,@topic,@description).deliver_now
    begin
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      flash[:notice] = "Houve um problema no envio do seu e-mail!"
      flash[:color] = "invalid"
      redirect_to(:back)
    end
    flash[:notice] = "Mensagem enviada com sucesso!"
    flash[:color] = "success"
    redirect_to(:back)
  end

end