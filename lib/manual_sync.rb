class ManualSync
  attr_accessor :rd_identifiers

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
  def check_problematic_applications(from,to,programs,for_filter,status)
    total_items = 0
    between = (to - from).to_i
    setup_expa_api
    between.downto(0).each do |day|
      params = {'per_page' => 25}
      date = (to - day)
      params['filters['+status+'][from]'] = date.to_s
      params['filters['+status+'][to]'] = date.to_s
      #params['filters[person_committee]'] = 1606 #from MC Brazil
      params['filters[programmes][]'] = programs #GCDP
      params['filters[for]'] = for_filter
      paging = EXPA::Applications.paging(params)
      total_items = paging[:total_items]
      #total_bazicon = ExpaApplication.gv.get_completed_in(Time.new(date.year,date.month,date.day,0,0,0,'+00:00'),Time.new(date.year,date.month,date.day,23,59,59,'+00:00')).count
      puts date.to_s
      puts 'No EXPA: ' + total_items.to_s
      #puts 'No Bazicon: ' + total_bazicon.to_s
      #if total_bazicon != total_items
        xp_applications = EXPA::Applications.list_by_param(params)
        #b_applications = ExpaApplication.gt.get_completed_in(Time.new(date.year,date.month,date.day,0,0,0,'+00:00'),Time.new(date.year,date.month,date.day,23,59,59,'+00:00')).map {|x| [x.xp_id, x] }.to_h
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
      #end
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

  #created_at date_matched date_an_signed date_approved experience_start_date experience_end_date
  def check_problematic_opportunities
    from = Date.new(2017,1,1)
    to = Date.new(2017,02,22)

    puts 'Check Opportunities'
    total_items = 0
    between = (to - from).to_i
    setup_expa_api
    between.downto(0).each do |day|
      params = {'per_page' => 100}
      date = (to - day)
      params['filters[created][from]'] = date.to_s
      params['filters[created][to]'] = date.to_s
      params['filters[committee]'] = 1606 #from MC Brazil
      paging = EXPA::Opportunities.paging(params)
      total_items = paging[:total_items]
      puts date.to_s
      puts 'No EXPA: ' + total_items.to_s
      xp_opportunities = EXPA::Opportunities.list_by_param(params)
      xp_opportunities.each do |xp_opportunity|
        begin
          xp_opportunity = EXPA::Opportunities.find_by_id(xp_opportunity.id)
          opportunity = ExpaOpportunity.find_by_xp_id(xp_opportunity.id)
          opportunity = ExpaOpportunity.new if opportunity.nil?

          opportunity.update_from_expa(xp_opportunity)
          opportunity.save
        rescue => exception
          puts 'ACHAR O BUG'
          puts xp_opportunity.id unless xp_opportunity.id.nil?
          puts exception.to_s
          puts exception.backtrace
        end
      end
    end
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

    people = [1197660]
    people.each do |person_id|
      person = ExpaPerson.find_by_xp_id(person_id)
      if !person.nil?# and !DigitalTransformation.hash_entities_podio_expa[I18n.transliterate(person.xp_home_lc.xp_name).upcase].nil?
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
        puts I18n.transliterate(person.xp_home_lc.xp_name).upcase
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