class JobsWorker
  include Shoryuken::Worker

  QUEUE_NAME = 'jobs'

  shoryuken_options queue: QUEUE_NAME, auto_delete: false, body_parser: JSON

  def perform(sqs_msg, body)
    Shoryuken.logger.info("Received message: '#{body}'")

    begin
      body["name"].constantize.call
    rescue
      raise NameError, "Not a defined job"
    end
  end
end
