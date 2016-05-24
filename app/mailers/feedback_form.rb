class FeedbackForm < ApplicationMailer

  def send_feedback(email,name,topic, description)

    @email = email
    @name = name
    @topic = topic
    @description = description
    mail(to: @email, subject: "Feedback relacionado ao tópico #{@topic}")

  end


end
