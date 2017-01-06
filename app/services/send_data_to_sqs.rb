class SendDataToSqs
  require 'slack-notifier'

  SLACK_WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL']

  def self.call(params)
    new(params).call
  end

  attr_reader :params, :status

  def initialize(params)
    @params = params
    @status = true
  end

  def call
    @status = false unless perform_on_worker

    notify_on_slack if @status

    @status
  end

  private

  def perform_on_worker
    AiesecGlobalWorker.perform_async(@params)
  end

  def notify_on_slack
    notifier = Slack::Notifier.new "#{SLACK_WEBHOOK_URL}", channel: "#sqs-notifications",
                                                           username: "Notifier"

    notifier.ping(text: "Nova Mensagem enviada à fila :incoming_envelope:\n\n&gt; Parâmetros: #{params}",
                         icon_emoji: ':email:')
  end
end
