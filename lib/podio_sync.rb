class PodioSync
  attr_accessor :rd_identifiers
  @@expires_at = nil

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
    loggin
  end

  def loggin
    if Podio.client.nil? || @@expires_at.nil? || @@expires_at < (Time.now + 600)
      Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
      auth = Podio.client.authenticate_with_credentials(ENV['PODIO_USERNAME'], ENV['PODIO_PASSWORD'])
      @@expires_at = auth.expires_at
      puts 'LOGIN'
    end
  end

  def update_ogx_person(person_id, status, date)
    loggin
    case status
      when 'approved'
        fields = {}
        fields['data-do-approved'] = { start: date.strftime('%Y-%m-%d %H:%M:%S')} unless date.nil?
        attributes = {:fields => fields}
        Podio::Item.update( person_id, attributes )
      when 'realized'
        fields = {}
        fields['data-do-realize'] = { start: date.strftime('%Y-%m-%d %H:%M:%S')} unless date.nil?
        attributes = {:fields => fields}
        Podio::Item.update( person_id, attributes )
    end
  end

  #Create a Podio item on Leads OGX with the applications achieved
  def send_ogx_application(application, podio_id)
    loggin
    fields = {}
    fields['application-created-at'] = {'start' => application.xp_created_at.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_created_at.nil?
    fields['person'] = application.xp_person.podio_id unless application.xp_person.podio_id.nil?
    fields['status'] = ExpaApplication.xp_statuses[application.xp_status] + 1 unless application.xp_status.nil? || ExpaApplication.xp_statuses[application.xp_status] > 5
    fields['ep-link'] = ('https://experience.aiesec.org/#/people/' + application.xp_person.xp_id.to_s) unless application.xp_person.xp_id.nil? 
    fields['ep-lc'] = DigitalTransformation.hash_expa_podio[application.xp_person.xp_home_lc.xp_id] unless application.xp_person.xp_home_lc.xp_id.nil?
    fields['opportunity-title'] = application.xp_opportunity.xp_title unless application.xp_opportunity.xp_title.nil?
    fields['opportunity-earliest-start-date'] = {'start' => application.xp_opportunity.xp_earliest_start_date.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_opportunity.xp_earliest_start_date.nil? 
    fields['opportunity-latest-end-date'] = {'start' => application.xp_opportunity.xp_latest_end_date.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_opportunity.xp_latest_end_date.nil?
    fields['opportunity-application-close-date'] = {'start' => application.xp_opportunity.xp_applications_close_date.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_opportunity.xp_applications_close_date.nil?
    fields['opportunity-lc-2'] = application.xp_opportunity.xp_home_lc.xp_full_name unless application.xp_opportunity.xp_home_lc.xp_full_name.nil? 
    fields['opportunity-mc'] = DigitalTransformation.hash_mcs_podio_expa[application.xp_opportunity.xp_home_lc.xp_parent.xp_id][:podio] unless application.xp_opportunity.xp_home_lc.xp_parent.nil?
    fields['application-date-accepted'] = {'start' => application.xp_date_matched.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_date_matched.nil?
    fields['application-date-approved'] = {'start' => application.xp_date_approved.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_date_approved.nil?
    fields['application-date-realized'] = {'start' => application.xp_date_realized.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_date_realized.nil?
    fields['application-date-completed'] = {'start' => application.xp_date_completed.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_date_completed.nil?
  
    case application.xp_opportunity.xp_programmes["id"]
      when 1
        fields['programme'] = 1
      when 2
        fields['programme'] = 2
      when 5
        fields['programme'] = 3
      when 3
        fields['programme'] = 4
      when 4
        fields['programme'] = 5
    end
    #puts fields

    attributes = {:fields => fields}

    if !application.podio_id.nil? && Podio::Item.find(application.podio_id)
      Podio::Item.update( application.podio_id, attributes )
    else
      podio_id = Podio::Item.create(20633687, attributes)
      application.podio_id = podio_id['item_id'].to_i
      application.save
    end
  end

  #Create a Podio item o Leads ICX or Update it
  def send_icx_application(application,podio_id)
    loggin
    fields = {}
    fields['titulo'] = application.xp_person.xp_full_name unless application.xp_person.nil?
    fields['host-lc'] = DigitalTransformation.hash_expa_podio[application.xp_opportunity.xp_home_lc.xp_id] unless application.xp_opportunity.xp_home_lc.xp_id.nil?
    fields['op-id'] = application.xp_opportunity_id unless application.xp_opportunity_id.nil?
    fields['ep-id'] = application.xp_person_id unless application.xp_person_id.nil?
    fields['ep-email'] = [{'type' => 'home', 'value' => application.xp_person.xp_email}] unless application.xp_person.nil?
    fields['status'] = ExpaApplication.xp_statuses[application.xp_status] + 1 unless application.xp_status.nil? || ExpaApplication.xp_statuses[application.xp_status] > 5
    fields['application-created-at'] = {'start' => application.xp_created_at.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_created_at.nil?
    fields['application-date-accepted'] = {'start' => application.xp_date_matched.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_date_matched.nil?
    fields['application-date-approved'] = {'start' => application.xp_date_approved.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_date_approved.nil?
    fields['ep-mc'] = DigitalTransformation.hash_mcs_podio_expa[application.xp_person.xp_home_lc.xp_parent.xp_id][:podio] unless application.xp_person.xp_home_lc.xp_parent.nil?
    fields['home-lc'] = 1 # application.xp_person.xp_home_lc.xp_full_name unless application.xp_person.xp_home_lc.nil?
    fields['opportunity'] = podio_id unless podio_id.nil?

    # Sincronizar com o APP Delivery
    # fields['application-date-realized'] = {'start' => application.xp_date_realized.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_date_realized.nil?
    # fields['application-date-completed'] = {'start' => application.xp_date_completed.strftime('%Y-%m-%d %H:%M:%S')} unless application.xp_date_completed.nil?
    podio_app_id = nil

    case application.xp_opportunity.xp_programmes["id"]
      when 1
        podio_app_id = 19352693
        # fields['programme'] = 1
      when 2
        podio_app_id = 20228970
        # fields['programme'] = 2
      when 5
        podio_app_id = 20229037
        # fields['programme'] = 3
      # when 3
        # fields['programme'] = 4
      # when 4
        # fields['programme'] = 5
    end
    #puts fields

    # gv 1 gt 2 ge 5

    attributes = {:fields => fields}

    if !application.podio_id.nil? && Podio::Item.find(application.podio_id)
      Podio::Item.update( application.podio_id, attributes )
    else
      podio_id = Podio::Item.create(podio_app_id, attributes)
      application.podio_id = podio_id['item_id'].to_i
      application.save
    end
  end

  def send_icx_opportunity(xp_opportunity)
    loggin
    fields = {}
    fields['titulo'] = xp_opportunity.xp_title unless xp_opportunity.xp_title.nil?
    # fields['link-2'] = ('https://experience.aiesec.org/#/opportunities/' + xp_opportunity.xp_id.to_s) unless xp_opportunity.nil?
    fields['office'] = DigitalTransformation.hash_expa_podio[xp_opportunity.xp_home_lc.xp_id] unless xp_opportunity.xp_home_lc.xp_id.nil?
    fields['applications-count'] = xp_opportunity.xp_application_count unless xp_opportunity.xp_application_count.nil?
    fields['oppenings'] = xp_opportunity.xp_openings unless xp_opportunity.xp_openings.nil?
    fields['available-oppenings'] = xp_opportunity.xp_available_openings unless xp_opportunity.xp_available_openings.nil?
    fields['earliest-start-date'] = {'start' => xp_opportunity.xp_earliest_start_date.strftime('%Y-%m-%d %H:%M:%S')} unless xp_opportunity.xp_earliest_start_date.nil?
    fields['latest-end-date'] = {'start' => xp_opportunity.xp_latest_end_date.strftime('%Y-%m-%d %H:%M:%S')} unless xp_opportunity.xp_latest_end_date.nil?
    fields['applications-close-date'] = {'start' => xp_opportunity.xp_applications_close_date.strftime('%Y-%m-%d %H:%M:%S')} unless xp_opportunity.xp_applications_close_date.nil?
    # fields['created-at'] = {'start' => xp_opportunity.xp_created_at.strftime('%Y-%m-%d %H:%M:%S')} unless xp_opportunity.xp_created_at.nil?
    case xp_opportunity.xp_programmes["id"]
      when 1
        fields['programme'] = 1
      when 2
        fields['programme'] = 2
      when 5
        fields['programme'] = 3
      when 3
        fields['programme'] = 4
      when 4
        fields['programme'] = 5
    end

    attributes = {:fields => fields}

    if !xp_opportunity.podio_id.nil? && Podio::Item.find(xp_opportunity.podio_id)
      Podio::Item.update( xp_opportunity.podio_id, attributes )
    else
      podio_id = Podio::Item.create(18283999, attributes)
      xp_opportunity.podio_id = podio_id['item_id'].to_i
      xp_opportunity.save
    end
    xp_opportunity.podio_id
  end

  def update_podio
    Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
    Podio.client.authenticate_with_credentials(ENV['PODIO_USERNAME'], ENV['PODIO_PASSWORD'])

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
          Sync.new.send_to_rd(person, nil, self.rd_identifiers[:form_podio_offline], nil)
          person = nil
        rescue => exception
          puts exception.to_s
          return
        end
      end
    end
  end
end