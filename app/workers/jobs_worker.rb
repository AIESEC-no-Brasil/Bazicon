class JobsWorker
  include Shoryuken::Worker
  require 'slack-notifier'

  QUEUE_NAME = 'jobs'
  SLACK_WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL']

  shoryuken_options queue: QUEUE_NAME, auto_delete: false, body_parser: JSON

  def perform(sqs_msg, body)
    Shoryuken.logger.info("Received message: '#{body}'")

    notify_on_slack("Mensagem consumida :envelope_with_arrow:", body)

    begin
      klass = body[:klass].constantize.new

      if body.has_key? :params
        notify_and_delete_message(sqs_msg, body) if klass.send body[:method], body[:params]
      else
        notify_and_delete_message(sqs_msg, body) if klass.send body[:method]
      end
    rescue
      raise NameError, "Not a defined job"
    end
  end

  private

  def notify_on_slack(message, params)
    notifier = Slack::Notifier.new "#{SLACK_WEBHOOK_URL}", channel: "#sqs-jobs",
                                                           username: "Notifier"

    notifier.ping(text: "#{message}\n\n&gt; Parâmetros: #{params}",
                         icon_emoji: ':email:')
  end

  def notify_and_delete_message(sqs_msg, body)
    sqs_msg.delete

    notify_on_slack("Mensagem excluida", body)
  end
end
