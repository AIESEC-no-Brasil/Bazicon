class JobsWorker
  include Shoryuken::Worker

  QUEUE_NAME = 'jobs'

  shoryuken_options queue: QUEUE_NAME, auto_delete: false, body_parser: JSON

  def perform(sqs_msg, body)
    Shoryuken.logger.info("Received message: '#{body}'")

    begin
      klass = body["klass"].constantize.new

      if body.has_key? "params"
        klass.send body["method"], body["params"]
      else
        klass.send body["method"]
      end
    rescue
      raise NameError, "Not a defined job"
    end
  end
end
