class FormsController < ApplicationController


  def show_feedback_form


  end

  def send_feedback

    @email = params[:email]
    @name = params[:name]
    @topic = params[:topic]
    @description = params[:description]
    mail = FeedbackForm.send_feedback(@email,@name,@topic,@description)
    mail.deliver_now
    mail.

    redirect_to index_path
  end

end