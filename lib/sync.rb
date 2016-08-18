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
      params['filters[person_home_mc][]'] = 1606 #from MC Brazil
      params['filters[opportunity_programme][]'] = programs #GCDP
      total_items = EXPA::Applications.list_by_param(params)

      if !total_items.nil? && total_items.length > 0
        total_pages = (total_items.length / params['per_page']) + 1

        for i in total_pages.downto(1)
          params['page'] = i
          applications = EXPA::Applications.list_by_param(params)
          applications.each do |xp_application|
            xp_application = EXPA::Applications.find_by_id(xp_application.id)
            xp_application.opportunity = EXPA::Opportunities.find_by_id(xp_application.opportunity.id)
            xp_application.person = EXPA::People.find_by_id(xp_application.person.id)
            application = ExpaApplication.find_by_xp_id(xp_application.id)
            application = ExpaApplication.new if application.nil?

            application.update_from_expa(EXPA::Applications.get_attributes(xp_application.id))
            application.save

            person = ExpaPerson.find_by_xp_id(application.xp_person.xp_id)
            send_to_rd(application.xp_person, nil, status, nil) if !person.nil? && application.xp_person.xp_status != person.xp_status
          end
        end
      end

      sync.get_error = false
      sync.count_itens = total_items.length
      sync.end_sync = DateTime.now
      sync.save
    end
  end

  def update_podio
    Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
    Podio.client.authenticate_with_credentials(ENV['PODIO_USERNAME'], ENV['PODIO_PASSWORD'])
    EXPAHelper.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])

    people = ExpaPerson.where.not(xp_id: nil).where.not(xp_email: nil).where("control_podio NOT LIKE '%baziconX%'").order(created_at: :desc)
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

        puts Podio::Item.create(podio_app_decided_leads, {:fields => fields})
        if person.control_podio.nil?
          json = {}
        else
          json = JSON.parse(person.control_podio)
        end

        unless json.include?('podio_status') && json['podio_status'] == 'baziconX'
          json['podio_status'] = 'baziconX'
          person.control_podio = json.to_json.to_s
          person.save
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
      json_to_rd.merge!{
      }
    end
    uri = URI(ENV['RD_STATION_URL'])
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req.body = json_to_rd.to_json
    begin
      response = https.request(req)
      puts 'RD Message: '+response.message
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

      setup_expa_api

      params = {'per_page' => 500}
      params['filters[created_at][from]'] = from.to_s
      params['filters[created_at][to]'] = to.to_s
      params['filters[person_home_mc][]'] = 1606 #from MC Brazil
      params['filters[opportunity_programme][]'] = [1] #GCDP
      total_items = EXPA::Applications.list_by_param(params)
      puts 'Esses negos tudo: ' + total_items.length.to_s

      if !total_items.nil? && total_items.length > 0
        total_pages = (total_items.length / params['per_page']) + 1

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

      sync.get_error = false
      sync.count_itens = total_items.length
      sync.end_sync = DateTime.now
      sync.save
    end
    puts 'FINISHING BIG SYNC' 
  end
end