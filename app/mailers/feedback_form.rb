class FeedbackForm < ApplicationMailer
  DEFAULT_TO_EMAIL = 'vivianecosta2794@gmail.com'

  def send_feedback(email,name,topic, description)

    @email = email
    @name = name
    @topic = topic
    @description = description
    mail(to: DEFAULT_TO_EMAIL, subject: "Feedback relacionado ao tópico #{@topic}")

  end


end
