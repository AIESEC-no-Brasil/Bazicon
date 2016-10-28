class Sync
  attr_accessor :rd_identifiers
  attr_accessor :rd_tags

  def initialize
    self.rd_identifiers = {
        :test => 'test', #This is the identifier that should always be used during test phase
        :form_podio_offline => 'form-podio-offline',
        :expa => 'expa',
        :open => 'open',
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
    people = nil
    SyncControl.new do |sync|
      sync.start_sync = DateTime.now
      sync.sync_type = 'open_people'

      setup_expa_api
      time = SyncControl.get_last('open_people')
      time = Time.now - 60*60 if time.nil? # 1 hour windows
      people = EXPA::People.list_everyone_created_after(time)
      people.each do |xp_person|
        if ExpaPerson.exist?(xp_person)
          xp_person = EXPA::People.find_by_id(xp_person.id)
          person = ExpaPerson.find_by_xp_id(xp_person.id)
          person = ExpaPerson.find_by_xp_email(xp_person.email) if person.nil?
          person.update_from_expa(xp_person)
          person.save
        else
          person = ExpaPerson.new
          person.update_from_expa(xp_person)
          person.save
          send_to_rd(person, nil, self.rd_identifiers[:open], nil)
        end
      end

      sync.get_error = false
      sync.count_itens = people.length
      sync.end_sync = DateTime.now
      sync.save
    end

    puts "Listed #{people.length} people finishing #{Time.now}"
  end

  #params
  #status - a String with the application status
  #programs - a Array of the programs
  def update_status(status, programs)
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
      sync.start_sync = DateTime.now
      sync.sync_type = 'applied_'+filter

      setup_expa_api
      time = SyncControl.get_last('applied_people').strftime('%F')
      time = Date.today.to_s if time.nil?

      params = {'per_page' => 100}
      params['filters['+filter+'][from]'] = time
      params['filters['+filter+'][to]'] = Date.today.to_s
      params['filters[person_committee]'] = 1606 #from MC Brazil
      params['filters[programmes][]'] = [1] #GCDP
      params['filters[for]'] = 'people' #GCDP
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
              xp_application = EXPA::Applications.find_by_id(xp_application.id)
              xp_application.opportunity = EXPA::Opportunities.find_by_id(xp_application.opportunity.id)
              xp_application.person = EXPA::People.find_by_id(xp_application.person.id)
              application = ExpaApplication.find_by_xp_id(xp_application.id)
              application = ExpaApplication.new if application.nil?

              to_rd = xp_application.person.status.to_s != application.xp_person.xp_status.to_s
              application.update_from_expa(EXPA::Applications.get_attributes(xp_application.id))
              application.save

              person = ExpaPerson.find_by_xp_id(application.xp_person.xp_id)
              send_to_rd(application.xp_person, application, status, nil) if !person.nil? && to_rd
            rescue => exception
              puts 'ACHAR O BUG'
              puts xp_application.id unless xp_application.id.nil?
              puts exception.to_s
              puts exception.backtrace
            end
          end
        end
      end

      sync.get_error = false
      sync.count_itens = total_items
      sync.end_sync = DateTime.now
      sync.save
    end
  end

  def update_podio
    Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
    Podio.client.authenticate_with_credentials(ENV['PODIO_USERNAME'], ENV['PODIO_PASSWORD'])
    #EXPAHelper.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])

    people = ExpaPerson.where.not(xp_id: nil).where.not(xp_email: nil).where.not(entity_exchange_lc: nil).where("control_podio NOT LIKE '%baziconX%' or control_podio is null").order(created_at: :desc)
    people.each do |person|
      if !person.entity_exchange_lc.nil?
        next if DigitalTransformation.hash_entities_podio_expa[person.entity_exchange_lc.xp_name].nil?
        if person.interested_program == 'global_volunteer'
          podio_app_decided_leads = 15290822
          sub_product = nil
          sub_product = ExpaPerson.interested_sub_products[person.interested_sub_product] + 1 unless person.interested_sub_product.nil?
        elsif person.interested_program == 'global_talents'
          podio_app_decided_leads = 15290822 #15291951
          sub_product = nil
          sub_product = ExpaPerson.interested_sub_products[person.interested_sub_product] - 4 unless person.interested_sub_product.nil?
        else
          podio_app_decided_leads = 15290822 #GCDP
          sub_product = nil
        end

        fields = {}
        fields['data-inscricao'] = {'start' => person.xp_created_at.strftime('%Y-%m-%d %H:%M:%S')} unless person.xp_created_at.nil?
        fields['title'] = person.xp_full_name unless person.xp_full_name.nil?
        fields['expa-id'] = person.xp_id unless person.xp_id.nil?
        fields['email'] = [{'type' => 'home', 'value' => person.xp_email}] unless person.xp_email.nil?

        if !person.customized_fields.nil? && JSON.parse(person.customized_fields).key?('telefone')
          fields['telefone'] = [{'type' => 'home', 'value' => JSON.parse(person.customized_fields)['telefone']}]
        elsif !person.xp_phone.nil?
          fields['telefone'] = [{'type' => 'home', 'value' => person.xp_phone.to_s}]
        end

        fields['cl-marcado-no-expa-nao-conta-expansao-ainda'] = DigitalTransformation.hash_entities_podio_expa[person.entity_exchange_lc.xp_name]['ids'][1] unless person.entity_exchange_lc.nil?
        fields['location-inscrito-escreve-isso-opcionalmente-no-expa'] = person.xp_location unless person.xp_location.blank?
        fields['sub-produto'] = sub_product unless sub_product.nil?

        unless person.control_podio.nil?
          fields['universidade'] = podio_helper_find_item_by_unique_id(JSON.parse(person.control_podio)['universidade']['item_id'], 'universidade')[0]['item_id'].to_i if JSON.parse(person.control_podio).key?('universidade')
          fields['curso'] = podio_helper_find_item_by_unique_id(JSON.parse(person.control_podio)['curso']['item_id'], 'curso')[0]['item_id'].to_i if JSON.parse(person.control_podio).key?('curso')
        end

        unless person.how_got_to_know_aiesec.nil?
          fields['como-conheceu-a-aiesec'] = ExpaPerson.how_got_to_know_aiesecs[person.how_got_to_know_aiesec]
        end

        unless person.travel_interest.nil?
          fields['prioridade-de-contato'] = ExpaPerson.travel_interests[person.travel_interest]
        end

        contato = []
        contato << 1 if person.want_contact_by_email
        contato << 2 if person.want_contact_by_phone
        contato << 3 if person.want_contact_by_whatsapp
        fields['preferencia-de-contato'] = contato

        #fields['direto-do-expa'] = 2 if 

        Podio::Item.create(podio_app_decided_leads, {:fields => fields})
        if person.control_podio.nil?
          json = {}
        else
          json = JSON.parse(person.control_podio)
        end

        unless json.include?('podio_status') && json['podio_status'] == 'baziconX'
          json['podio_status'] = 'baziconX'
          person.update_attribute(:control_podio, json.to_json.to_s)
        end
      end
    end
  end

  #Leads that subscribed during a moment that OP was not working
  def almost_leads_to_podio
    Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
    Podio.client.authenticate_with_credentials(ENV['PODIO_USERNAME'], ENV['PODIO_PASSWORD'])

    people = ExpaPerson.where.not(xp_email: nil).where("created_at <= :limit", {limit: Date.today - 3}).where("control_podio NOT LIKE '%baziconX%'").order(created_at: :desc)
    people.each do |person|
      if !person.entity_exchange_lc.nil?
        if person.interested_program == 'global_volunteer'
          podio_app_decided_leads = 15290822
          sub_product = nil
          sub_product = ExpaPerson.interested_sub_products[person.interested_sub_product] + 1 unless person.interested_sub_product.nil?
        elsif person.interested_program == 'global_talents'
          podio_app_decided_leads = 15291951
          sub_product = nil
          sub_product = ExpaPerson.interested_sub_products[person.interested_sub_product] - 4 unless person.interested_sub_product.nil?
        else
          podio_app_decided_leads = 15290822 #GCDP
          sub_product = nil
        end

        fields = {}
        fields['data-inscricao'] = {'start' => person.xp_created_at.strftime('%Y-%m-%d %H:%M:%S')} unless person.xp_created_at.nil?
        fields['title'] = person.xp_full_name unless person.xp_full_name.nil?
        fields['expa-id'] = person.xp_id unless person.xp_id.nil?
        fields['email'] = [{'type' => 'home', 'value' => person.xp_email}] unless person.xp_email.nil?

        if !person.customized_fields.nil? && JSON.parse(person.customized_fields).key?('telefone')
          fields['telefone'] = [{'type' => 'home', 'value' => JSON.parse(person.customized_fields)['telefone']}]
        elsif !person.xp_phone.nil?
          fields['telefone'] = [{'type' => 'home', 'value' => person.xp_phone.to_s}]
        end

        fields['cl-marcado-no-expa-nao-conta-expansao-ainda'] = DigitalTransformation.hash_entities_podio_expa[person.entity_exchange_lc.xp_name]['ids'][1] unless person.entity_exchange_lc.nil?
        fields['location-inscrito-escreve-isso-opcionalmente-no-expa'] = person.xp_location unless person.xp_location.blank?
        fields['sub-produto'] = sub_product unless sub_product.nil?

        unless person.control_podio.nil?
          fields['universidade'] = podio_helper_find_item_by_unique_id(JSON.parse(person.control_podio)['universidade']['item_id'], 'universidade')[0]['item_id'].to_i if JSON.parse(person.control_podio).key?('universidade')
          fields['curso'] = podio_helper_find_item_by_unique_id(JSON.parse(person.control_podio)['curso']['item_id'], 'curso')[0]['item_id'].to_i if JSON.parse(person.control_podio).key?('curso')
        end

        unless person.how_got_to_know_aiesec.nil?
          fields['como-conheceu-a-aiesec'] = ExpaPerson.how_got_to_know_aiesecs[person.how_got_to_know_aiesec]
        end

        unless person.travel_interest.nil?
          fields['prioridade-de-contato'] = ExpaPerson.travel_interests[person.travel_interest]
        end

        contato = []
        contato << 1 if person.want_contact_by_email
        contato << 2 if person.want_contact_by_phone
        contato << 3 if person.want_contact_by_whatsapp
        fields['preferencia-de-contato'] = contato

        fields['cadastrado-no-op'] = 2

        Podio::Item.create(podio_app_decided_leads, {:fields => fields})
        if person.control_podio.nil?
          json = {}
        else
          json = JSON.parse(person.control_podio)
        end

        unless json.include?('podio_status') && json['podio_status'] == 'baziconX'
          json['podio_status'] = 'baziconX'
          person.update_attribute(:control_podio, json.to_json.to_s)
        end
      end
    end
  end

  def rd_from_podio_offline_lead
    Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
    Podio.client.authenticate_with_credentials(ENV['PODIO_2_USERNAME'], ENV['PODIO_2_PASSWORD'])

    attributes = {:sort_by => 'last_edit_on'}
    app_id = 14573133 # App ORS oGCDP from Space Leads oGCDP
    attributes[:filters] = {118893658 => 1, 'created_on' =>{'from' => (Time.now - 1.day).strftime('%Y-%m-%d %H:%M:%S'), 'to' => (Time.now + 1.day).strftime('%Y-%m-%d %H:%M:%S')}}

    response = Podio.connection.post do |req|
      req.url "/item/app/#{app_id}/filter/"
      req.body = attributes
    end

    items = response.body['items']

    items.each do |item|
      mail_index = item['fields'].count
      for i in 0...item['fields'].count
        mail_index = i if item['fields'][i]['external_id'] == 'email'
      end
      unless mail_index == item['fields'].count
        begin
          Podio::Item.update(item['item_id'], {:fields => {'enviado-para-rd-station-bazicon' => 2}})
          person = ExpaPerson.new
          person.xp_email = item['fields'][mail_index]['values'][0]['value']
          send_to_rd(person, nil, self.rd_identifiers[:form_podio_offline], nil)
          person = nil
        rescue => exception
          puts exception.to_s
          return
        end
      end
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

  def big_sync(from,to)
    puts 'STARTING BIG SYNC'
    SyncControl.new do |sync|
      sync.start_sync = DateTime.now
      sync.sync_type = 'big_sync'

      total_items = 0
      between = (to - from).to_i
      between.downto(0).each do |day|
        puts (to - day).to_s
        setup_expa_api

        params = {'per_page' => 100}
        params['filters[date_an_signed][from]'] = (to - day).to_s
        params['filters[date_an_signed][to]'] = (to - day).to_s
        params['filters[person_committee]'] = 1606 #from MC Brazil
        params['filters[programmes][]'] = [1] #GCDP
        params['filters[for]'] = 'people' #GCDP
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
                xp_application = EXPA::Applications.find_by_id(xp_application.id)
                xp_application.opportunity = EXPA::Opportunities.find_by_id(xp_application.opportunity.id)
                xp_application.person = EXPA::People.find_by_id(xp_application.person.id)
                application = ExpaApplication.find_by_xp_id(xp_application.id)
                application = ExpaApplication.new if application.nil?

                application.update_from_expa(xp_application)
                application.save
              rescue => exception
                puts 'ACHAR O BUG'
                puts xp_application.id unless xp_application.id.nil?
                puts exception.to_s
                puts exception.backtrace
              end
            end
          end
        end
      end

      sync.get_error = false
      sync.count_itens = total_items
      sync.end_sync = DateTime.now
      sync.save
    end
    puts 'FINISHING BIG SYNC' 
  end

  #created_at date_matched date_an_signed date_approved date_realized experience_start_date experience_end_date
  def check_problematic_applications(from,to)
    total_items = 0
    between = (to - from).to_i
    setup_expa_api
    between.downto(0).each do |day|
      params = {'per_page' => 100}
      date = (to - day)
      params['filters[created_at][from]'] = date.to_s
      params['filters[created_at][to]'] = date.to_s
      params['filters[person_committee]'] = 1606 #from MC Brazil
      params['filters[programmes][]'] = [1] #GCDP
      params['filters[for]'] = 'people' #OGX
      paging = EXPA::Applications.paging(params)
      total_items = paging[:total_items]
      total_bazicon = ExpaApplication.gv.get_completed_in(Time.new(date.year,date.month,date.day,0,0,0,'+00:00'),Time.new(date.year,date.month,date.day,23,59,59,'+00:00')).count
      puts date.to_s
      puts 'No EXPA: ' + total_items.to_s
      puts 'No Bazicon: ' + total_bazicon.to_s
      if total_bazicon != total_items
        xp_applications = EXPA::Applications.list_by_param(params)
        b_applications = ExpaApplication.gv.get_completed_in(Time.new(date.year,date.month,date.day,0,0,0,'+00:00'),Time.new(date.year,date.month,date.day,23,59,59,'+00:00')).map {|x| [x.xp_id, x] }.to_h
        xp_applications.each do |xp_application|
          #if !b_applications.has_key?(xp_application.id) || xp_application.xp_date_matched.nil? #xp_date_matched xp_date_approved xp_date_realized xp_date_completed
            begin
              #puts 'Application: '+ xp_app.id.to_s
              #puts 'Opportunity: '+ xp_app.opportunity.id.to_s + ' and programme ' + xp_app.opportunity.programmes.to_s
              xp_application = EXPA::Applications.find_by_id(xp_application.id)
              xp_application.opportunity = EXPA::Opportunities.find_by_id(xp_application.opportunity.id)
              xp_application.person = EXPA::People.find_by_id(xp_application.person.id)
              application = ExpaApplication.find_by_xp_id(xp_application.id)
              application = ExpaApplication.new if application.nil?

              application.update_from_expa(xp_application)
              application.save
            rescue => exception
              puts 'ACHAR O BUG'
              puts xp_application.id unless xp_application.id.nil?
              puts exception.to_s
              puts exception.backtrace
            end
          #end
        end
      end
    end
  end

  #created_at date_matched date_an_signed date_approved experience_start_date experience_end_date
  def check_problematic_people(from,to)
    puts 'Check People'
    total_items = 0
    between = (to - from).to_i
    setup_expa_api
    between.downto(0).each do |day|
      params = {'per_page' => 100}
      date = (to - day)
      params['filters[registered][from]'] = date.to_s
      params['filters[registered][to]'] = date.to_s
      params['filters[home_committee]'] = 1606 #from MC Brazil
      paging = EXPA::People.paging(params)
      total_items = paging[:total_items]
      total_bazicon = ExpaPerson.get_open_in(Time.new(date.year,date.month,date.day,0,0,0,'+00:00'),Time.new(date.year,date.month,date.day,23,59,59,'+00:00')).count
      puts date.to_s
      puts 'No EXPA: ' + total_items.to_s
      puts 'No Bazicon: ' + total_bazicon.to_s
      if total_bazicon != total_items
        xp_people = EXPA::People.list_by_param(params)
        b_people = ExpaPerson.get_open_in(Time.new(date.year,date.month,date.day,0,0,0,'+00:00'),Time.new(date.year,date.month,date.day,23,59,59,'+00:00')).map {|x| [x.xp_id, x] }.to_h
        xp_people.each do |xp_person|
          if !b_people.has_key?(xp_person.id)
            begin
              xp_person = EXPA::People.find_by_id(xp_person.id)
              person = ExpaPerson.find_by_xp_id(xp_person.id)
              person = ExpaPerson.new if person.nil?

              person.update_from_expa(xp_person)
              person.save
            rescue => exception
              puts 'ACHAR O BUG'
              puts xp_person.id unless xp_person.id.nil?
              puts exception.to_s
              puts exception.backtrace
            end
          end
        end
      end
    end
  end

  def send_to_od
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
    ws.save
  end

  def populate_od(from,to)
    between = (to - from).to_i
    between.downto(0).each do |day|
      analytics = EXPA::Applications.analisa({'start_date'=> to - day,'end_date'=> to - day})
      
      session = GoogleDrive::Session.from_config("client_secret.json")
      ws = session.spreadsheet_by_key("1A1wwdYUwTnqYV1EDdxfAUbcQORaPwp4_TQ_6jTRjeFE").worksheet_by_gid 625192524

      analytics.each_key do |key|
        row = ws.num_rows+1
        ws[row,1] = (to - day).day
        ws[row,2] = (to - day).month
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
        ws[row,1] = (to - day).day
        ws[row,2] = (to - day).month
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
      ws.save
    end
  end

  def resolvendo_tretas
    Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
    Podio.client.authenticate_with_credentials(ENV['PODIO_USERNAME'], ENV['PODIO_PASSWORD'])

    #people = [1129766,1129325,1129322,1129284,1128989,1120528,1120084,1116027,1111994,1110372,1109600,1036707,1151860,1136439,1140984,1129934,1140720,1129589,1102917,1093719,1102420,1102419,1127305,1123621,1129550,1101554,1103742,1104876,1105601,1105645,1106421,1107100,1107463,1107537,1107881,1107882,1107883,1107949,1107962,1108272,1108292,1108796,1110327,1110411,1111927,1112589,1112697,1112818,1113577,1120200,1120238,1120383,1120682,1120766,1120871,1120987,1121052,1121152,1121461,1121841,1122101,1122105,1122360,1123609,1123850,1124444,1124738,1142741,1154189,1144156,1156228,1151372,1150800,1151407,1156784,1144708,1145450,1136379,1155994,1146984,1143157,1156493,1154459,1121068,1120212,1112982,1060591,1099973,1074560,1143201,1142305,1139906,1139771,1140468,1137962,1136966,1136774,1136406,1135504,1131746,1129857,1129400,1129133,1127860,1127440,1123730,1115894,1114515,1114428,1114061,1112841,1111351,1110791,1109208,1104171,1101620,1100642,1100407,1099787,1098733,1098130,1098108,1097605,1096105,1094564,1094537,1091433,1152945,1152919,1145334,1143055,1134347,1131875,1138365,1138060,1129526,1117839,1131531,1102389,1121856,1131345,1108377,1115644,1119078,1123106,1131383,1152945,1152919,1145334,1143055,1134347,1131875,1138365,1138060,1122973,1122383,1121579,1120747,1120223,1118694,1123226,1126924,1150307,1150240,1144620,1139506,1139371,1138320,952531,1111673,1139251,1146955,1013170,1133900,1140205,1123900,1123904,1094419,1129560,1131354,1130082,1129816,294500,1124257,1119010,1121068,1112982,1099973,1125404,1136933,1133260,1124591,1114889,1121533]
    #people = [1155083]1163824,1164049,1165485,1167693,1077953,1079968,1080825,1081992,1082693,1090048,1091145,1074751,1096514,1079457,
    people = [1146198,1146195]
    people.each do |person_id|
      person = ExpaPerson.find_by_xp_id(person_id)
      if !person.nil? and !DigitalTransformation.hash_entities_podio_expa[I18n.transliterate(person.xp_home_lc.xp_name).upcase].nil?
        puts person.xp_id
        #puts person.entity_exchange_lc
        puts I18n.transliterate(person.xp_home_lc.xp_name).upcase
        if person.interested_program == 'global_volunteer'
          podio_app_decided_leads = 15290822
          sub_product = nil
          sub_product = ExpaPerson.interested_sub_products[person.interested_sub_product] + 1 unless person.interested_sub_product.nil?
        elsif person.interested_program == 'global_talents'
          podio_app_decided_leads = 15291951
          sub_product = nil
          sub_product = ExpaPerson.interested_sub_products[person.interested_sub_product] - 4 unless person.interested_sub_product.nil?
        else
          podio_app_decided_leads = 15290822 #GCDP
          sub_product = nil
        end

        fields = {}
        fields['data-inscricao'] = {'start' => person.xp_created_at.strftime('%Y-%m-%d %H:%M:%S')} unless person.xp_created_at.nil?
        fields['title'] = person.xp_full_name unless person.xp_full_name.nil?
        fields['expa-id'] = person.xp_id unless person.xp_id.nil?
        fields['email'] = [{'type' => 'home', 'value' => person.xp_email}] unless person.xp_email.nil?

        if !person.customized_fields.nil? && JSON.parse(person.customized_fields).key?('telefone')
          fields['telefone'] = [{'type' => 'home', 'value' => JSON.parse(person.customized_fields)['telefone']}]
        elsif !person.xp_phone.nil?
          fields['telefone'] = [{'type' => 'home', 'value' => person.xp_phone.to_s}]
        end

        fields['cl-marcado-no-expa-nao-conta-expansao-ainda'] = DigitalTransformation.hash_entities_podio_expa[person.entity_exchange_lc.xp_name]['ids'][1] unless person.entity_exchange_lc.nil?
        fields['cl-marcado-no-expa-nao-conta-expansao-ainda'] = DigitalTransformation.hash_entities_podio_expa[I18n.transliterate(person.xp_home_lc.xp_name).upcase]['ids'][1] if person.entity_exchange_lc.nil?
        fields['location-inscrito-escreve-isso-opcionalmente-no-expa'] = person.xp_location unless person.xp_location.blank?
        fields['sub-produto'] = sub_product unless sub_product.nil?

        unless person.control_podio.nil?
          fields['universidade'] = podio_helper_find_item_by_unique_id(JSON.parse(person.control_podio)['universidade']['item_id'], 'universidade')[0]['item_id'].to_i if JSON.parse(person.control_podio).key?('universidade')
          fields['curso'] = podio_helper_find_item_by_unique_id(JSON.parse(person.control_podio)['curso']['item_id'], 'curso')[0]['item_id'].to_i if JSON.parse(person.control_podio).key?('curso')
        end

        unless person.how_got_to_know_aiesec.nil?
          fields['como-conheceu-a-aiesec'] = ExpaPerson.how_got_to_know_aiesecs[person.how_got_to_know_aiesec]
        end

        unless person.travel_interest.nil?
          fields['prioridade-de-contato'] = ExpaPerson.travel_interests[person.travel_interest]
        end

        contato = []
        contato << 1 if person.want_contact_by_email
        contato << 2 if person.want_contact_by_phone
        contato << 3 if person.want_contact_by_whatsapp
        fields['preferencia-de-contato'] = contato

        Podio::Item.create(podio_app_decided_leads, {:fields => fields})
        if person.control_podio.nil?
          json = {}
        else
          json = JSON.parse(person.control_podio)
        end

        unless json.include?('podio_status') && json['podio_status'] == 'baziconX'
          json['podio_status'] = 'baziconX'
          person.update_attribute(:control_podio, json.to_json.to_s)
        end
        puts 'foi: '+person_id.to_s
      elsif !person.nil? and DigitalTransformation.hash_entities_podio_expa[I18n.transliterate(person.xp_home_lc.xp_name).upcase].nil?
        puts 'Na mão: '+person_id.to_s
      else
        xp_person = EXPA::People.find_by_id(person_id)
        person = ExpaPerson.find_by_xp_email(xp_person.email)
        person = ExpaPerson.new if person.nil?
        person.update_from_expa(xp_person)
        person.save
        puts 'nill: '+person_id.to_s
      end
    end
  end

  #get all new people on EXPA since last sync, save on DB and sent to RD
  def expa_refresh
    people = nil
    SyncControl.new do |sync|
      sync.start_sync = DateTime.now
      sync.sync_type = 'open_people'

      setup_expa_api
      time = Time.new(2016,10,7,0,0,0)
      people = EXPA::People.list_everyone_created_after(time)
      people.each do |xp_person|
        if ExpaPerson.exist?(xp_person)
          xp_person = EXPA::People.find_by_id(xp_person.id)
          person = ExpaPerson.find_by_xp_id(xp_person.id)
          person = ExpaPerson.find_by_xp_email(xp_person.email) if person.nil?
          person.update_from_expa(xp_person)
          person.save
        else
          person = ExpaPerson.new
          person.update_from_expa(xp_person)
          person.save
          send_to_rd(person, nil, self.rd_identifiers[:open], nil)
        end
      end

      sync.get_error = false
      sync.count_itens = people.length
      sync.end_sync = DateTime.now
      sync.save
    end

    puts "Listed #{people.length} people finishing #{Time.now}"
  end
end