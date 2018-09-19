class DigitalTransformationController < ApplicationController
  after_action :cors_set_access_control_headers

  expose :study_level, -> { DigitalTransformation.study_level }
  expose :universities, -> { DigitalTransformation.universities }
  expose :courses, -> { DigitalTransformation.courses }
  expose :sdgs_we_work, -> { DigitalTransformation.sdgs_we_work }
  expose :sub_product_global_talent, -> { DigitalTransformation.sub_product_global_talent }
  expose :sub_product_global_entrepreneur, -> { DigitalTransformation.sub_product_global_entrepreneur }
  expose :entities_ogcdp, -> { DigitalTransformation.entities_ogcdp }
  expose :entities_ogt, -> { DigitalTransformation.entities_ogt }
  expose :entities_oge, -> { DigitalTransformation.entities_oge }
  expose :travel_interest, -> { DigitalTransformation.travel_interest }
  expose :language_level, -> { DigitalTransformation.language_level }

  # GET /dt/difficulties
  def difficulties
    render layout: "empty"
  end

  # POST /dt/difficulties_success
  def difficulties_success
    user_name = params['userName']
    password = params['password']
    difficulty = params['difficulties']

    expa = EXPAHelper.auth(user_name, password)
    if expa.get_token.nil?
      flash['text-danger'] = 'Sua conta não foi encontrada. Verifique se você digitou seu e-mail e senha corretamente'
      return redirect_to digital_transformation_difficulties_path
    else
      current_person = EXPA::CurrentPerson.get_current_person
      user = ExpaPerson.find_by_xp_id(current_person.id)
      if user.nil?
        user = ExpaPerson.new
        user.update_from_expa(current_person)
        user.save
      end

      json = if user.customized_fields.nil?
               user.customized_fields = {}
             else
               JSON.parse(user.customized_fields)
             end

      hash_difficulty = {}
      hash_difficulty['field_name'] = 'O que te impediria de fazer um intercâmbio nas próximas férias?'
      hash_difficulty['type'] = 'text'
      hash_difficulty['value'] = difficulty
      json['difficulty'] = hash_difficulty

      user.customized_fields = json.to_json.to_s
      user.save
      @user = user
    end
    render layout: "empty"
  end

  # GET /dt/prevents
  def prevents
    prevents_options
    render layout: "empty"
  end

  # POST /dt/prevents_success
  def prevents_success
    user_name = params['userName']
    password = params['password']
    prevent_option = params['preventOption']
    prevent_detail = params['preventDetail']

    expa = EXPAHelper.auth(user_name, password)
    if expa.get_token.nil?
      flash['text-danger'] = 'Sua conta não foi encontrada. Verifique se você digitou seu e-mail e senha corretamente'
      return redirect_to digital_transformation_prevents_path
    else
      current_person = EXPA::CurrentPerson.get_current_person
      user = ExpaPerson.find_by_xp_id(current_person.id)
      if user.nil?
        user = ExpaPerson.new
        user.update_from_expa(current_person)
        user.save
      end

      prevents_options

      json = if user.customized_fields.nil?
               user.customized_fields = {}
             else
               JSON.parse(user.customized_fields)
             end

      hash_prevent = {}
      hash_prevent['field_name'] = 'O que te impediria de fazer um intercâmbio nas próximas férias?'
      hash_prevent['type'] = 'text'
      if prevent_option == @options.keys[-1]
        hash_prevent['value'] = prevent_detail
      else
        hash_prevent['value'] = @options[prevent_option]
      end

      json['prevents'] = hash_prevent

      user.customized_fields = json.to_json.to_s
      user.save
      @user = user
    end
    render layout: "empty"
  end

  # GET /dt/igcdp_interested
  def igcdp_interested
    @user = ExpaPerson.find_by_xp_id(session[:expa_id])
    reset_session; return redirect_to index_path if @user.nil?
    @people = ExpaPerson.where.not(xp_home_mc_id: ExpaOffice.find_by_xp_id(1606)).where("customized_fields LIKE ?", '%"foreign"%').where("customized_fields LIKE ?", '%GCDP%').includes(:xp_home_mc).includes(:xp_home_lc).order(xp_id: :desc)
    @people_to_show = ExpaPerson.where.not(xp_home_mc_id: ExpaOffice.find_by_xp_id(1606)).where("customized_fields LIKE ?", '%"foreign"%').where("customized_fields LIKE ?", '%GCDP%').includes(:xp_home_mc).includes(:xp_home_lc).order(xp_id: :desc).limit(100)
  end

  # GET /dt/igcdp_interested
  def igip_interested
    @user = ExpaPerson.find_by_xp_id(session[:expa_id])
    reset_session; return redirect_to index_path if @user.nil?
    @people = ExpaPerson.where.not(xp_home_mc_id: ExpaOffice.find_by_xp_id(1606)).where("customized_fields LIKE ?", '%"foreign"%').where("customized_fields LIKE ?", '%GIP%').includes(:xp_home_mc).includes(:xp_home_lc).order(xp_id: :desc)
    @people_to_show = ExpaPerson.where.not(xp_home_mc_id: ExpaOffice.find_by_xp_id(1606)).where("customized_fields LIKE ?", '%"foreign"%').where("customized_fields LIKE ?", '%GIP%').includes(:xp_home_mc).includes(:xp_home_lc).order(xp_id: :desc).limit(100)
  end

  # GET /expa/sign_up
  def expa_sign_up
    unless params.has_key?('programa') &&
        (params['programa'] == 'GCDP' || params['programa'] == 'GV' ||
          params['programa'] == 'GIP' || params['programa'] == 'GT' || params['programa'] == 'GE')
      redirect_to 'http://aiesec.org.br'
      return
    end
    render layout: "empty"
  end

  # POST /expa/sign_up
  def expa_sign_up_success2
    name = params['name']
    lastname = params['lastname']
    phone = params['phone']
    email = params['email']
    bithdate = params['dob'].to_date.strftime("%Y-%m-%d %H:%M:%S") unless params['dob'].nil?
    password = params['password']
    interested_program = params['programa']
    sdg = params['sdg']
    sub_product = params['sub-product']
    #how_got_to_know_aiesec = params['how-got-to-know-aiesec']
    university = params['university']
    course = params['course']
    study_level = params['study-level']
    lc = params['nearest_lc']
    travel_interest = params['travel_interest']
    english_level = params['english_level']
    spanish_level = params['spanish_level']
    want_contact_by_email = params['want_contact_by_email']
    want_contact_by_phone = params['want_contact_by_phone']
    want_contact_by_whatsapp = params['want_contact_by_whatsapp']
    campagin = params['campanha']

    if ExpaPerson.find_by_xp_aiesec_email(email) || ExpaPerson.find_by_xp_email(email)
      flash['text-danger'] = "Já existe uma conta com o e-mail #{email}. Tente logar clicando <a href='https://auth.aiesec.org/users/sign_in'>aqui</a>"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif sdg == ''
      flash['text-danger'] = "Nos conte qual SDG você gostaria de defender"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif (study_level == '4' ||
          study_level == '5' ||
          study_level == '6') &&
          (university == '' || course == '')
      flash['text-danger'] = "Campos 'Universidade' e 'Curso' são obrigatórios caso você tenha algum tipo de ensino superior"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif lc == ''
      flash['text-danger'] = "É necessário escolher o comitê mais perto de você para cadastrar uma nova conta"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif password.length < 8
      flash['text-danger'] = "Senha precisa ter no mínimo 8 caracteres"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    end

    podio_id = send_to_podio(name,lastname,phone,email,bithdate,interested_program,sub_product,sdg,university,
      course,lc,travel_interest,english_level,spanish_level,want_contact_by_email,want_contact_by_phone,want_contact_by_whatsapp,campagin)

    send_data_to_sqs(email, name, lastname, password, lc, interested_program)

    person = ExpaPerson.new
    person.xp_email = email.downcase
    person.xp_full_name = name

    case interested_program
      when 'GCDP', 'GV'
          office = ExpaOffice.find_by_xp_name(DigitalTransformation.entities_ogcdp[lc.to_i])
      when 'GIP', 'GT',
          office = ExpaOffice.find_by_xp_name(DigitalTransformation.entities_ogt[lc.to_i])
      when 'GE'
          office = ExpaOffice.find_by_xp_name(DigitalTransformation.entities_oge[lc.to_i])
      else
          office = ExpaOffice.find_by_xp_name(DigitalTransformation.entities_ogcdp[lc.to_i])
    end

    #Entidade mais próxima != Entidade EXPA
    person.entity_exchange_lc = office

    #Programa de interesse e sub-produto
    case interested_program
      when 'GCDP', 'GV'
        person.interested_program = :global_volunteer
        case sub_product.to_i
          when 1 then person.interested_sub_product = :global_volunteer_arab
          when 2 then person.interested_sub_product = :global_volunteer_east_europe
          when 3 then person.interested_sub_product = :global_volunteer_africa
          when 4 then person.interested_sub_product = :global_volunteer_asia
          when 5 then person.interested_sub_product = :global_volunteer_latam
        end
      when 'GIP', 'GT'
        person.interested_program = :global_talents
        case sub_product.to_i
          when 1 then person.interested_sub_product = :global_talents_educacional
          when 2 then person.interested_sub_product = :global_talents_IT
          when 3 then person.interested_sub_product = :global_talents_management
          when 4 then person.interested_sub_product = :global_talents_marketing
        end
      when 'GE'
        person.interested_program = :global_entrepreneur
        case sub_product.to_i
          when 1 then person.interested_sub_product = :global_entrepreneur_marketing
          when 2 then person.interested_sub_product = :global_entrepreneur_IT
          when 3 then person.interested_sub_product = :global_entrepreneur_management
          when 4 then person.interested_sub_product = :global_entrepreneur_engineering
        end
    end

    #TODO Tirar control_podio quando BAZICON lançar para OGX
    json = if person.control_podio.nil?
             person.control_podio = {}
           else
             JSON.parse(person.control_podio)
           end

    json['escolaridade'] = DigitalTransformation.study_level[study_level.to_i]

    case study_level.to_i
      when 4,5,6
        json['universidade'] = {item_id: DigitalTransformation.hash_universities_podio.values[university.to_i],
                                value: DigitalTransformation.hash_universities_podio.keys[university.to_i]}
        json['curso'] = {item_id: DigitalTransformation.hash_courses_podio.values[course.to_i],
                         value: DigitalTransformation.hash_courses_podio.keys[course.to_i]}
    end

    json['podio_status'] = 'lead_decidido'
    person.control_podio = json.to_json.to_s

    # escolaridade, universidade e curso
    json = if person.customized_fields.nil?
             person.customized_fields = {}
           else
             JSON.parse(person.customized_fields)
           end

    json['telefone'] = phone

    json['escolaridade'] = study_level

    case study_level
      when '4', '5', '6'
        json['universidade'] = university
        json['curso'] = course
    end
    person.customized_fields = json.to_json.to_s

    #como conheceu a AIESEC
    #person.how_got_to_know_aiesec = how_got_to_know_aiesec.to_i
    person.travel_interest = travel_interest.to_i
    person.interested_sdg = sdg.to_i unless sdg.nil?
    person.want_contact_by_email = (want_contact_by_email == 'on') ? true : false
    person.want_contact_by_phone = (want_contact_by_phone == 'on') ? true : false
    person.want_contact_by_whatsapp = (want_contact_by_whatsapp == 'on') ? true : false

    person.podio_id = podio_id['item_id'].to_i

    tags = interested_program
    tags = campagin.to_s+", "+interested_program unless campagin.nil? || campagin.empty?
    person.save(validate: false)
    xp_sync = Sync.new
    xp_sync.send_to_rd(person, nil, xp_sync.rd_identifiers[:open], tags)

    case interested_program
      when 'GCDP', 'GV'
        redirect_to 'http://brasil.aiesec.org.br/obrigado-por-se-inscrever-ogv'
      when 'GIP', 'GT'
        redirect_to 'http://brasil.aiesec.org.br/global-talent-obrigado'
      when 'GE'
        redirect_to 'http://brasil.aiesec.org.br/global-entrepreneur-obrigado'
      else
        redirect_to 'http://brasil.aiesec.org.br/obrigado-por-se-inscrever-ogv'
    end
  end

  private

  def send_data_to_sqs(email, name, lastname, password, lc, interested_program)
    params = { email: email,
               name: name,
               lastname: lastname,
               password: password,
               lc: lc,
               interested_program: interested_program
             }

    SendDataToSqs.call(params)
  end

  def prevents_options
    @options = {}
    @options['value1'] = 'Não tenho dinheiro'
    @options['value2'] = 'Meus pais não deixam'
    @options['value3'] = 'Minhas férias são muito curtas'
    @options['value4'] = 'Não sei falar outro idioma'
    @options['value5'] = 'Não encontro vagas no país de minha preferência'
    @options['value6'] = 'Nunca viajei sozinho(a)'
    @options['other'] = 'Outro'
  end

  def send_to_podio(name,lastname,phone,email,bithdate,interested_program,sub_product,sdg,
      university,course,lc,travel_interest,english_level,spanish_level,
      want_contact_by_email,want_contact_by_phone,want_contact_by_whatsapp,campagin)

    Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
    Podio.client.authenticate_with_credentials(ENV['PODIO_USERNAME'], ENV['PODIO_PASSWORD'])

    if interested_program == 'GCDP' || interested_program == 'GV'
      podio_app_decided_leads = 15290822
    elsif interested_program == 'GIP' || interested_program == 'GT'
      podio_app_decided_leads = 17057001
    elsif interested_program == 'GE'
      podio_app_decided_leads = 17057629
    else
      podio_app_decided_leads = 15290822 #GCDP
    end

    sync = Sync.new
    fields = {}
    fields['data-inscricao'] = {'start' => Time.now.strftime('%Y-%m-%d %H:%M:%S')}
    fields['title'] = name + ' ' + lastname  unless name.nil? || lastname.nil?
    fields['email'] = [{'type' => 'home', 'value' => email}] unless email.nil?
    fields['telefone'] = [{'type' => 'home', 'value' => phone}]
    fields['cl-marcado-no-expa-nao-conta-expansao-ainda'] = DigitalTransformation.get_entity_ids_by_order(lc.to_i,interested_program)[1] unless lc.nil?
    fields['sub-produto'] = sub_product.to_i unless sub_product.nil? || interested_program == 'GV'
    # fields['sdg-de-interesse'] = sdg.to_i unless sdg.nil? || interested_program != 'GV'
    fields['universidade'] = sync.podio_helper_find_item_by_unique_id(DigitalTransformation.hash_universities_podio.values[university.to_i], 'universidade')[0]['item_id'].to_i unless university.empty?
    fields['curso'] = sync.podio_helper_find_item_by_unique_id(DigitalTransformation.hash_courses_podio.values[course.to_i], 'curso')[0]['item_id'].to_i unless course.empty?
    #fields['como-conheceu-a-aiesec'] = how_got_to_know_aiesec.to_i unless how_got_to_know_aiesec.nil?
    # fields['prioridade-de-contato'] = travel_interest.to_i unless travel_interest.nil?
    fields['nivel-de-ingles'] = english_level.to_i unless english_level.nil?
    fields['nivel-de-espanhol'] = spanish_level.to_i unless spanish_level.nil?
    fields['data-de-nascimento'] = { start: (bithdate) } unless bithdate.nil?
    puts fields

    # contato = []
    # contato << 1 if want_contact_by_email
    # contato << 2 if want_contact_by_phone
    # contato << 3 if want_contact_by_whatsapp
    # fields['preferencia-de-contato'] = contato
    attibutes = {:fields => fields}
    attibutes[:tags] = [campagin] unless campagin.nil? || campagin.empty?

    Podio::Item.create(podio_app_decided_leads, attibutes)
  end

  def cors_set_access_control_headers
    headers['X-Frame-Options'] = 'ALLOW-FROM http://aiesec.org.br'
  end
end
