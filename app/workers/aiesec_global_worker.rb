class AiesecGlobalWorker
  include Shoryuken::Worker
  require 'slack-notifier'

  QUEUE_NAME = 'default'
  SLACK_WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL']

  shoryuken_options queue: QUEUE_NAME, auto_delete: false, body_parser: JSON

  def perform(sqs_msg, body)
    notify_on_slack("Mensagem consumida :envelope_with_arrow:", body)

    Shoryuken.logger.info("Received message: '#{body}'")

    notify_and_delete_message(sqs_msg, body) if SendToExpa.call(body)
  end

  private

  def notify_on_slack(message, params)
    notifier = Slack::Notifier.new "#{SLACK_WEBHOOK_URL}", channel: "#sqs-notifications",
                                                           username: "Notifier"

    notifier.ping(text: "#{message}\n\n&gt; Parâmetros: #{params}",
                         icon_emoji: ':email:')
  end

  def notify_and_delete_message(sqs_msg, body)
    sqs_msg.delete

    notify_on_slack("Mensagem excluida", body)
  end
end
