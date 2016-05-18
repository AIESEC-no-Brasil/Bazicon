class DigitalTransformationController < ApplicationController
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
        (params['programa'] == 'GCDP' ||
            params['programa'] == 'GIP')
      redirect_to 'http://aiesec.org.br'
      return
    end
    render layout: "empty"
  end

  # POST /expa/sign_up
  def expa_sign_up_success
    name = params['name']
    lastname = params['lastname']
    phone = params['phone']
    email = params['email']
    password = params['password']
    interested_program = params['programa']
    sub_product = params['sub-product']
    how_got_to_know_aiesec = params['how-got-to-know-aiesec']
    university = params['university']
    course = params['course']
    study_level = params['study-level']
    lc = params['nearest_lc']

    if ExpaPerson.find_by_xp_aiesec_email(email) || ExpaPerson.find_by_xp_email(email)
      flash['text-danger'] = "Já existe uma conta com o e-mail #{email}. Tente logar clicando <a href='https://auth.aiesec.org/users/sign_in'>aqui</a>"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif (interested_program == 'GCDP' && sub_product == '') ||
        (interested_program == 'GIP' && sub_product == '')
      flash['text-danger'] = "Você deve selecionar um sub-produto"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif how_got_to_know_aiesec == ''
      flash['text-danger'] = "Nos conte como conheceu a AIESEC"
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

    url = 'https://opportunities.aiesec.org/auth'

    agent = Mechanize.new {|a| a.ssl_version, a.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE}
    page = agent.get(url)

    auth_form = page.forms[1]
    auth_form.field_with(:name => 'user[email]').value = email
    auth_form.field_with(:name => 'user[first_name]').value = name
    auth_form.field_with(:name => 'user[last_name]').value = lastname
    auth_form.field_with(:name => 'user[password]').value = password
    auth_form.field_with(:name => 'user[country]').value = 'Brazil'
    auth_form.field_with(:name => 'user[mc]').value = '1606'
    auth_form.field_with(:name => 'user[lc]').value = DigitalTransformation.hash_entities_podio_expa.values[lc.to_i]['ids'][0]
    auth_form.field_with(:name => 'user[lc_input]').value = DigitalTransformation.hash_entities_podio_expa.keys[lc.to_i]

    begin
      page = agent.submit(auth_form, auth_form.buttons.first)
    rescue => exception
      #TODO insert sign up error screen. This will be useful when EXPA/OP get offline
      puts exception.to_s
    ensure
      person = ExpaPerson.new
      person.xp_email = email.downcase
      person.xp_full_name = name

      office = ExpaOffice.find_by_xp_name(DigitalTransformation.hash_entities_podio_expa.keys[lc.to_i])
      if office.nil?
        office = ExpaOffice.new

        DigitalTransformation.hash_entities_podio_expa.each do |entity|
          if entity[0] == DigitalTransformation.hash_entities_podio_expa.keys[lc.to_i]
            office.xp_id = entity[1]['ids'][0]
            office.xp_full_name = entity[0]
            office.xp_name = entity[0]
            office.save
            break
          end
        end
      end

      #Entidade mais próxima != Entidade EXPA
      person.entity_exchange_lc = office

      #Programa de interesse e sub-produto
      case interested_program
        when 'GCDP'
          person.interested_program = 'global_volunteer'
          case sub_product.to_i
            when 1 then person.interested_sub_product = 'global_volunteer_arab'
            when 2 then person.interested_sub_product = 'global_volunteer_east_europe'
            when 3 then person.interested_sub_product = 'global_volunteer_africa'
            when 4 then person.interested_sub_product = 'global_volunteer_asia'
            when 5 then person.interested_sub_product = 'global_volunteer_latam'
          end
        when 'GIP'
          person.interested_program = 'global_talents'
          case sub_product.to_i
            when 1 then person.interested_sub_product = 'global_talents_start_up'
            when 2 then person.interested_sub_product = 'global_talents_educacional'
            when 3 then person.interested_sub_product = 'global_talents_IT'
            when 4 then person.interested_sub_product = 'global_talents_management'
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
      person.how_got_to_know_aiesec = how_got_to_know_aiesec.to_i

      person.save(validate: false)
      xp_sync = ExpaRdSync.new
      xp_sync.send_to_rd(person, nil, xp_sync.rd_identifiers[:open], nil)
    end
    redirect_to 'https://auth.aiesec.org/users/sign_in'
  end

  private

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
end