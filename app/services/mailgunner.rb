class Mailgunner
  attr_reader :from, :to,:subject, :text, :mg_client

  def self.call(from, to, subject, text)
    new(from, to, subject, text).call
  end

  def initialize(from, to, subject, text)
    @from = from
    @to = to
    @subject = subject
    @text = text

    @mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
  end

  def call
    @mg_client.send_message 'aiesec.org.br', message_params
  end

  private

  def message_params
    { from: @from, to: @to, subject: @subject, html: @text }
  end
end
