class AiesecGlobalMiddleware
  def call(worker_instance, queue, sqs_msg, body)
    puts 'Before Work'
    yield
    puts 'After Work'
  end
end
