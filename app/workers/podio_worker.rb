class PodioWorker
  include Shoryuken::Worker

  QUEUE_NAME = 'podio_queue'

  shoryuken_options queue: QUEUE_NAME, auto_delete: false, body_parser: JSON

  def perform(sqs_msg, body)
    Shoryuken.logger.info("Received message: '#{body}'")
    status = false

    status = true if perform_on_worker(body)

    sqs_msg.delete if status
  end

  private

  def perform_on_worker(message)
    application = ExpaApplication.find_by(xp_id: message['xp_id'])
    status = message['status']
    for_filter = message['for_filter']

    send_data_to_podio(application, status, for_filter)
  end

  def send_data_to_podio
    podio_date = application.xp_date_approved if status == 'approved'
    podio_date = application.xp_date_realized if status == 'realized'
    podio_sync = PodioSync.new
    if for_filter == 'people'
      podio_sync.update_ogx_person(application.xp_person.podio_id,status,podio_date) unless application.xp_person.nil? || application.xp_person.podio_id.nil?
      podio_sync.send_ogx_application(application, application.xp_person.podio_id) unless application.xp_person.nil?
    elsif for_filter == 'opportunities'
      opportunity_podio_id = podio_sync.send_icx_opportunity(application.xp_opportunity)
      podio_sync.send_icx_application(application,opportunity_podio_id)
    end
  end
end
