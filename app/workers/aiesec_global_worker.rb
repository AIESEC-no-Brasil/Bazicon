class AiesecGlobalWorker
  include Shoryuken::Worker

  QUEUE_NAME = 'default'

  shoryuken_options queue: QUEUE_NAME, auto_delete: false, body_parser: JSON

  def perform(sqs_msg, body)
    Shoryuken.logger.info("Received message: '#{body}'")
    sqs_msg.delete if SendToExpa.new(body).call
  end
end
