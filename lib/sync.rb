class Sync
  require 'slack-notifier'

  SLACK_WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL']

  attr_accessor :rd_identifiers
  attr_accessor :rd_tags

  def initialize
    self.rd_identifiers = {
        :test => 'test', #This is the identifier that should always be used during test phase
        :form_podio_offline => 'form-podio-offline',
        :expa => 'expa',
        :open => 'open',
        :open_opportunity => 'open_opportunity',
        :landing_0 => 'completou-cadastro',
        :landing_1 => 'form-video-suporte-aiesec',
        :landing_2 => '15-dicas-para-planejar-sua-viagem-sem-imprevistos',
        :in_progress => 'in_progress',
        :rejected => 'rejected',
        :accepted => 'accepted',
        :approved => 'approved'
    }

    self.rd_tags = {
        :gip => 'GIP',
        :gcdp => 'GCDP'
    }
  end

  #get all new people on EXPA since last sync, save on DB and sent to RD
  def get_new_people_from_expa
    job_status = true
    people = nil
    SyncControl.new do |sync|
      sync.start_sync = DateTime.now
      sync.sync_type = 'open_people'

      setup_expa_api
      time = SyncControl.get_last('open_people') || Time.now - 12*60*60 if time.nil? # 12 hour windows

      people = EXPA::People.list_everyone_created_after(time)

      people.each do |xp_person|
        if ExpaPerson.exist?(xp_person)
          xp_person = EXPA::People.find_by_id(xp_person.id)
          person = ExpaPerson.find_by_xp_id(xp_person.id)
          person = ExpaPerson.find_by_xp_email(xp_person.email) if person.nil?
          person.update_from_expa(xp_person)
          job_status = false unless person.save
          create_ep_managers(person)
        else
          person = ExpaPerson.new
          person.update_from_expa(xp_person)
          job_status = false unless person.save
          job_status = false unless send_to_rd(person, nil, self.rd_identifiers[:open], nil)
          create_ep_managers(person)
        end
      end

      sync.get_error = false
      sync.count_itens = people.length
      sync.end_sync = DateTime.now
      job_status = false unless sync.save
    end

    puts "Listed #{people.length} people finishing #{Time.now}"

    job_status
  end

  def create_ep_managers(person)
    setup_expa_api

    data = EXPA::People.list_single_person(person.xp_id)

    managers = []

    managers = data['managers'] unless data['managers'].nil?

    if managers.any?
      managers.each do |manager|
        unless ExpaPersonManager.find_by(expa_person_id: person.id, expa_manager_id: ExpaManager.id_by_xp_id(manager['id']))
          if ExpaManager.find_by(xp_id: manager['id'])
            expa_person_manager = ExpaPersonManager.create(expa_person_id: person.id,
                                                           expa_manager_id: ExpaManager.id_by_xp_id(manager['id'])
                                                          )

            puts "Person Manager created: #{expa_person_manager}"
          else
            expa_manager = ExpaManager.create(xp_id: manager['id'],
                                              name: manager['full_name'],
                                              email: manager['email'],
                                            )

            puts "Manager created: #{expa_manager}"

            expa_person_manager = ExpaPersonManager.create(expa_person_id: person.id,
                                                           expa_manager_id: expa_manager.id
                                                          )

            puts "Person Manager created: #{expa_person_manager}"
          end
        else
          puts "Already created, skipping"
        end
      end
    end
  end

  #get all new people on EXPA since last sync, save on DB and sent to RD
  def get_new_opportunities_from_expa
    opportunities = nil
    SyncControl.new do |sync|
      sync.start_sync = DateTime.now
      sync.sync_type = 'open_opportunity'

      setup_expa_api
      #time = SyncControl.get_last('open_opportunity')
      time = Time.now - 24*60*60 #if time.nil? # 1 day windows
      opportunities = EXPA::Opportunities.list_created_after(time)
      opportunities.each do |xp_opportunity|
        if ExpaOpportunity.exist?(xp_opportunity)
          xp_opportunity = EXPA::Opportunities.find_by_id(xp_opportunity.id)
          opportunity = ExpaOpportunity.find_by_xp_id(xp_opportunity.id)
          opportunity.update_from_expa(xp_opportunity)
          opportunity.save
          create_opportunity_managers(opportunity)
        else
          opportunity = ExpaOpportunity.new
          opportunity.update_from_expa(xp_opportunity)
          opportunity.save
          create_opportunity_managers(opportunity)
        end
        PodioSync.new.send_icx_opportunity(xp_opportunity)
      end

      sync.get_error = false
      sync.count_itens = opportunities.length
      sync.end_sync = DateTime.now
      sync.save
    end

    puts "Listed #{opportunities.length} opportunities finishing #{Time.now}"
  end

  def create_opportunity_managers(opportunity)
    setup_expa_api

    data = EXPA::Opportunities.list_single_opportunity(opportunity.xp_id)

    managers = []

    managers = data['managers'] unless data['managers'].nil?

    if managers.any?
      managers.each do |manager|
        unless ExpaOpportunityManager.find_by(expa_opportunity_id: opportunity.id, expa_manager_id: ExpaManager.id_by_xp_id(manager['id']))
          if ExpaManager.find_by(xp_id: manager['id'])
            expa_opportunity_manager = ExpaOpportunityManager.create(expa_opportunity_id: opportunity.id,
                                                                     expa_manager_id: ExpaManager.id_by_xp_id(manager['id'])
                                                                    )

            puts "Opportunity Manager created: #{expa_opportunity_manager}"
          else
            expa_manager = ExpaManager.create(xp_id: manager['id'],
                                      name: manager['full_name'],
                                      email: manager['email'],
                                      profile_photo_url: manager['profile_photo_url']
                                    )

            puts "Manager created: #{expa_manager}"

            expa_opportunity_manager = ExpaOpportunityManager.create(expa_opportunity_id: opportunity.id,
                                                                     expa_manager_id: expa_manager.id
                                                                    )

            puts "Opportunity Manager created: #{expa_opportunity_manager}"
          end
        else
          opportunity_manager = ExpaManager.find_by(xp_id: manager['id'])
          old_email = opportunity_manager.email
          new_email = manager['email']
          opportunity_manager.update(email: manager['email'])
          puts "Already created, updating email from #{old_email} to #{new_email}"
        end
      end
    end
  end

  #params
  #status - a String with the application status
  #programs - a Array of the programs
  def update_status(params) #status, programs, for_filter
    job_status = true
    status = params["status"]
    programs = params["programs"].split(",").map { |s| s.to_i }
    for_filter = params["for_filter"]

    filter = nil
    case status
      when 'open' then filter = 'created_at'
      when 'accepted' then filter = 'date_matched'
      when 'in_progress' then filter = 'date_an_signed'
      when 'approved' then filter = 'date_approved'
      when 'realized' then filter = 'experience_start_date'
      when 'completed' then filter = 'experience_end_date'
    end

    SyncControl.new do |sync|
      status_updates = 0
      mails_success = 0
      mails_failures = 0
      exceptions_count = 0

      sync.start_sync = DateTime.now
      sync.sync_type = 'applied_'+filter

      setup_expa_api
      time = SyncControl.get_last('applied_'+filter).strftime('%F')
      time = Date.today.to_s if time.nil?

      params = {'per_page' => 25}
      params['filters['+filter+'][from]'] = time
      params['filters['+filter+'][to]'] = Date.today.to_s
      params['filters[programmes][]'] = programs #GCDP
      params['filters[for]'] = for_filter #people #opportunities
      paging = EXPA::Applications.paging(params)
      total_items = paging[:total_items]
      puts 'Esses negos tudo: ' + total_items.to_s
      if !total_items.nil? && total_items > 0
        total_pages = paging[:total_pages]

        for i in total_pages.downto(1)
          params['page'] = i
          applications = EXPA::Applications.list_by_param(params)
          applications.each do |xp_application|
            begin
              data = EXPA::Applications.find_by_id(xp_application.id)
              data.opportunity = EXPA::Opportunities.find_by_id(data.opportunity.id)
              data.person = EXPA::People.find_by_id(data.person.id) if for_filter == 'people'
              application = ExpaApplication.find_by_xp_id(data.id) || ExpaApplication.new
              to_rd = application.xp_person.nil? || data.status.to_s != application.xp_status.to_s

              unless application.xp_status == data.status.to_s.downcase.gsub(' ','_')
                status_updates += 1
                application.update_from_expa(data)
                application.save

                create_opportunity_managers(application.xp_opportunity)
                create_ep_managers(application.xp_person)

                send_emails(application, data.status.to_s.downcase.gsub(' ', '_')) ? mails_success += 1 : mails_failures += 1
              end
              application.update_from_expa(data)
              application.save

              send_to_rd(application.xp_person, application, status, nil) if to_rd
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
            rescue => exception
              exceptions_count += 1
              puts 'ACHAR O BUG'
              puts xp_application.id unless xp_application.id.nil?
              puts exception.to_s
              sleep 3600 unless exception['error_description'].nil?
              puts exception.backtrace
            end
          end
        end
      end

      sync.get_error = false
      sync.count_itens = total_items
      sync.end_sync = DateTime.now
      job_status = false unless sync.save

      send_slack_notification(total_items, mails_success, mails_failures, status_updates, status, exceptions_count)
    end

    job_status
  end

  def send_slack_notification(total_items, mails_success, mails_failures, status_updates, status, exceptions_count)
    notifier = Slack::Notifier.new "#{SLACK_WEBHOOK_URL}", channel: "#update-status",
                                                           username: "Notifier"

    notifier.ping(text: "Report status #{status}:\n\n&gt; Itens sincronizados: #{total_items}\n"\
                        "&gt;Atualizações de status: #{status_updates}\n"\
                        "&gt;Emails: #{mails_success} sucessos e #{mails_failures} falhas\n&gt;Exceções: #{exceptions_count}",
                         icon_emoji: ':email:')
  end

  def send_emails(application, status)
    SendOpportunityManagerMail.call(application, status) if opportunity_in_brazil(application)
    SendEpManagerMail.call(application, status) if person_in_brazil(application)
  end

  def opportunity_in_brazil(application)
    if application.try(:xp_opportunity).try(:xp_home_lc).try(:xp_parent)
      application.xp_opportunity.xp_home_lc.xp_parent.xp_id == 1606
    else
      false
    end
  end

  def person_in_brazil(application)
    if application.try(:xp_person).try(:xp_home_mc)
      application.xp_person.xp_home_mc.xp_id == 1606
    else
      false
    end
  end

  #TODO: Delete after migrate everything to Bazicon/EXPA and do not use Podio anymore
  def podio_helper_find_item_by_unique_id(unique_id, option)
    attributes = {:sort_by => 'last_edit_on'}
    if option == 'universidade'
      app_id = 14568134
      attributes[:filters] = {117992837 => unique_id}
    elsif option == 'curso'
      app_id = 14568143
      attributes[:filters] = {117992834 => unique_id}
    end

    response = Podio.connection.post do |req|
      req.url "/item/app/#{app_id}/filter/"
      req.body = attributes
    end

    Podio::Item.collection(response.body).first
  end

  #TODO: Delete after migrate everything to Bazicon/EXPA and do not use Podio anymore
  def podio_helper_find_item_by_expa_id(expa_id)
    attributes = {:sort_by => 'last_edit_on'}
    attributes[:filters] = {117786190 => {'from'=>expa_id,'to'=>expa_id}}

    response = Podio.connection.post do |req|
      req.url '/item/app/15290822/filter/'
      req.body = attributes
    end
    Podio::Item.collection(response.body).first
  end

  def send_to_rd(person, application, identifier, tag)
    #TODO: colocar todos os campos do peoples e applications aqui no RD
    #TODO: colocar breaks conferindo todos os campos
    json_to_rd = {}
    json_to_rd['token_rdstation'] = ENV['RD_STATION_TOKEN']
    json_to_rd['identificador'] = identifier
    json_to_rd['email'] = person.xp_email unless person.xp_email.nil?
    json_to_rd['nome'] = person.xp_full_name unless person.xp_full_name.nil?
    json_to_rd['expa_id'] = person.xp_id unless person.xp_id.nil?
    json_to_rd['data_de_nascimento'] = person.xp_birthday_date unless person.xp_birthday_date.nil?
    json_to_rd['entidade'] = person.xp_home_lc.xp_name unless person.xp_home_lc.nil?
    json_to_rd['pais'] = person.xp_home_mc.xp_name unless person.xp_home_mc.nil?
    json_to_rd['status'] = person.xp_status unless person.xp_status.nil?
    json_to_rd['entrevistado'] = person.xp_interviewed  unless person.xp_interviewed.nil?
    json_to_rd['telefone'] = person.xp_phone unless person.xp_phone.nil?
    json_to_rd['pagamento'] = person.xp_payment unless person.xp_payment.nil?
    json_to_rd['nps'] = person.xp_nps_score unless person.xp_nps_score.nil?
    json_to_rd['entidade_OGX'] = person.entity_exchange_lc.xp_name unless person.entity_exchange_lc.nil?
    json_to_rd['como_conheceu_AIESEC'] = person.how_got_to_know_aiesec unless person.how_got_to_know_aiesec.nil?
    json_to_rd['programa_interesse'] = person.interested_program unless person.interested_program.nil?
    json_to_rd['sub_produto_interesse'] = person.interested_sub_product unless person.interested_sub_product.nil?
    json_to_rd['tag'] = tag unless tag.nil?
    unless application.nil?
      json_to_rd['identificador'] = 'application_'+identifier.to_s
      json_to_rd['last_application_id'] = application.xp_id
      json_to_rd['last_application_opportunity_id'] = application.xp_opportunity.xp_id
      json_to_rd['last_application_opportunity_title'] = application.xp_opportunity.xp_title
    end
    uri = URI(ENV['RD_STATION_URL'])
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req.body = json_to_rd.to_json
    begin
      response = https.request(req)
      #puts 'RD Message: '+response.message
    rescue => exception
      puts exception.to_s
    end
  end

  def setup_expa_api
    if EXPA.client.nil?
      xp = EXPA.setup()
      xp.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    end
  end

  def send_to_od
    job_status = true
    day = Date.today - 1
    setup_expa_api
    analytics = EXPA::Applications.analisa({'start_date'=> day,'end_date'=> day})

    session = GoogleDrive::Session.from_config("client_secret.json")
    ws = session.spreadsheet_by_key("1A1wwdYUwTnqYV1EDdxfAUbcQORaPwp4_TQ_6jTRjeFE").worksheet_by_gid 625192524

    analytics.each_key do |key|
      row = ws.num_rows+1
      ws[row,1] = day.day
      ws[row,2] = day.month
      ws[row,3] = 'APD'
      ws[row,4] = key
      ws[row,5] = analytics[key][100][:apd] unless analytics[key][100].nil?
      ws[row,6] = analytics[key][1731][:apd] unless analytics[key][1731].nil?
      ws[row,7] = analytics[key][32][:apd] unless analytics[key][32].nil?
      ws[row,8] = analytics[key][1248][:apd] unless analytics[key][1248].nil?
      ws[row,9] = analytics[key][1300][:apd] unless analytics[key][1300].nil?
      ws[row,10] = analytics[key][1766][:apd] unless analytics[key][1766].nil?
      ws[row,11] = analytics[key][283][:apd] unless analytics[key][283].nil?
      ws[row,12] = analytics[key][1178][:apd] unless analytics[key][1178].nil?
      ws[row,13] = analytics[key][436][:apd] unless analytics[key][436].nil?
      ws[row,14] = analytics[key][988][:apd] unless analytics[key][988].nil?
      ws[row,15] = analytics[key][286][:apd] unless analytics[key][286].nil?
      ws[row,16] = analytics[key][284][:apd] unless analytics[key][284].nil?
      ws[row,17] = analytics[key][943][:apd] unless analytics[key][943].nil?
      ws[row,18] = analytics[key][434][:apd] unless analytics[key][434].nil?
      ws[row,19] = analytics[key][233][:apd] unless analytics[key][233].nil?
      ws[row,20] = analytics[key][479][:apd] unless analytics[key][479].nil?
      ws[row,21] = analytics[key][1666][:apd] unless analytics[key][1666].nil?
      ws[row,22] = analytics[key][232][:apd] unless analytics[key][232].nil?
      ws[row,23] = analytics[key][2061][:apd] unless analytics[key][2061].nil?
      ws[row,24] = analytics[key][437][:apd] unless analytics[key][437].nil?
      ws[row,25] = analytics[key][231][:apd] unless analytics[key][231].nil?
      ws[row,26] = analytics[key][723][:apd] unless analytics[key][723].nil?
      ws[row,27] = analytics[key][148][:apd] unless analytics[key][148].nil?
      ws[row,28] = analytics[key][854][:apd] unless analytics[key][854].nil?
      ws[row,29] = analytics[key][288][:apd] unless analytics[key][288].nil?
      ws[row,30] = analytics[key][541][:apd] unless analytics[key][541].nil?
      ws[row,31] = analytics[key][467][:apd] unless analytics[key][467].nil?
      ws[row,32] = analytics[key][777][:apd] unless analytics[key][777].nil?
      ws[row,33] = analytics[key][1121][:apd] unless analytics[key][1121].nil?
      ws[row,34] = analytics[key][958][:apd] unless analytics[key][958].nil?
      ws[row,35] = analytics[key][1816][:apd] unless analytics[key][1816].nil?
      ws[row,36] = analytics[key][230][:apd] unless analytics[key][230].nil?
      ws[row,37] = analytics[key][435][:apd] unless analytics[key][435].nil?
      ws[row,38] = analytics[key][287][:apd] unless analytics[key][287].nil?
      ws[row,39] = analytics[key][1003][:apd] unless analytics[key][1003].nil?
      ws[row,40] = analytics[key][1368][:apd] unless analytics[key][1368].nil?
      ws[row,41] = analytics[key][909][:apd] unless analytics[key][909].nil?
      row = ws.num_rows+1
      ws[row,1] = day.day
      ws[row,2] = day.month
      ws[row,3] = 'RE'
      ws[row,4] = key
      ws[row,5] = analytics[key][100][:re] unless analytics[key][100].nil?
      ws[row,6] = analytics[key][1731][:re] unless analytics[key][1731].nil?
      ws[row,7] = analytics[key][32][:re] unless analytics[key][32].nil?
      ws[row,8] = analytics[key][1248][:re] unless analytics[key][1248].nil?
      ws[row,9] = analytics[key][1300][:re] unless analytics[key][1300].nil?
      ws[row,10] = analytics[key][1766][:re] unless analytics[key][1766].nil?
      ws[row,11] = analytics[key][283][:re] unless analytics[key][283].nil?
      ws[row,12] = analytics[key][1178][:re] unless analytics[key][1178].nil?
      ws[row,13] = analytics[key][436][:re] unless analytics[key][436].nil?
      ws[row,14] = analytics[key][988][:re] unless analytics[key][988].nil?
      ws[row,15] = analytics[key][286][:re] unless analytics[key][286].nil?
      ws[row,16] = analytics[key][284][:re] unless analytics[key][284].nil?
      ws[row,17] = analytics[key][943][:re] unless analytics[key][943].nil?
      ws[row,18] = analytics[key][434][:re] unless analytics[key][434].nil?
      ws[row,19] = analytics[key][233][:re] unless analytics[key][233].nil?
      ws[row,20] = analytics[key][479][:re] unless analytics[key][479].nil?
      ws[row,21] = analytics[key][1666][:re] unless analytics[key][1666].nil?
      ws[row,22] = analytics[key][232][:re] unless analytics[key][232].nil?
      ws[row,23] = analytics[key][2061][:re] unless analytics[key][2061].nil?
      ws[row,24] = analytics[key][437][:re] unless analytics[key][437].nil?
      ws[row,25] = analytics[key][231][:re] unless analytics[key][231].nil?
      ws[row,26] = analytics[key][723][:re] unless analytics[key][723].nil?
      ws[row,27] = analytics[key][148][:re] unless analytics[key][148].nil?
      ws[row,28] = analytics[key][854][:re] unless analytics[key][854].nil?
      ws[row,29] = analytics[key][288][:re] unless analytics[key][288].nil?
      ws[row,30] = analytics[key][541][:re] unless analytics[key][541].nil?
      ws[row,31] = analytics[key][467][:re] unless analytics[key][467].nil?
      ws[row,32] = analytics[key][777][:re] unless analytics[key][777].nil?
      ws[row,33] = analytics[key][1121][:re] unless analytics[key][1121].nil?
      ws[row,34] = analytics[key][958][:re] unless analytics[key][958].nil?
      ws[row,35] = analytics[key][1816][:re] unless analytics[key][1816].nil?
      ws[row,36] = analytics[key][230][:re] unless analytics[key][230].nil?
      ws[row,37] = analytics[key][435][:re] unless analytics[key][435].nil?
      ws[row,38] = analytics[key][287][:re] unless analytics[key][287].nil?
      ws[row,39] = analytics[key][1003][:re] unless analytics[key][1003].nil?
      ws[row,40] = analytics[key][1368][:re] unless analytics[key][1368].nil?
      ws[row,41] = analytics[key][909][:re] unless analytics[key][909].nil?
    end

    job_status = false unless ws.save
  end

end
