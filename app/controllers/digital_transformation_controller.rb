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
    elsif (interested_program == 'GCDP' && sub_product == 'Sub-Produtos Cidadão Global') ||
        (interested_program == 'GIP' && sub_product == 'Sub-Produtos Talentos Globais')
      flash['text-danger'] = "Você deve selecionar um sub-produto"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif how_got_to_know_aiesec == 'Como conheceu a AIESEC?'
      flash['text-danger'] = "Nos conte como conheceu a AIESEC"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif (study_level == 'Ensino Superior' ||
          study_level == 'Mestrado' ||
          study_level == 'Doutorado') &&
          (university == 'Universidade' || course == 'Curso')
      flash['text-danger'] = "Campos 'Universidade' e 'Curso' são obrigatórios caso você tenha algum tipo de ensino superior"
      return redirect_to expa_sign_up_url + '?programa=' + interested_program
    elsif lc == 'Comitê Local'
      flash['text-danger'] = "É necessário escolher o comitê mais perto de você para cadastrar uma nova conta"
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
    auth_form.field_with(:name => 'user[lc]').value = DigitalTransformation.hash_entities_podio_expa[lc]['ids'][0]
    auth_form.field_with(:name => 'user[lc_input]').value = lc

    begin
      page = agent.submit(auth_form, auth_form.buttons.first)
    rescue => exception
      puts exception.to_s
    else
      expa = EXPAHelper.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])

      time = Time.now - 60 # 1 minute windows
      people = EXPA::People.list_everyone_created_after(time)
      people.each do |xp_person|
        if xp_person.email == email
          person = ExpaPerson.new
          person.update_from_expa(xp_person)

          office = ExpaOffice.find_by_xp_name(lc)
          if office.nil?
            office = ExpaOffice.new

            DigitalTransformation.hash_entities_podio_expa.each do |entity|
              if entity[0] == lc
                office.xp_id = entity[1]['ids'][0] unless data.id.nil?
                office.xp_full_name = entity
                office.xp_name = entity
                break
              end
            end

            office.save!
          end

          #Entidade mais próxima != Entidade EXPA
          person.entity_exchange_lc = office

          #Programa de interesse e sub-produto
          case interested_program
            when 'GCDP'
              person.interested_program = 'global_volunteer'
              case DigitalTransformation.sub_product_global_citizen.index(sub_product)
                when 1 then person.interested_sub_product = 'global_volunteer_arab'
                when 2 then person.interested_sub_product = 'global_volunteer_east_europe'
                when 3 then person.interested_sub_product = 'global_volunteer_africa'
                when 4 then person.interested_sub_product = 'global_volunteer_asia'
                when 5 then person.interested_sub_product = 'global_volunteer_latam'
              end
            when 'GIP'
              person.interested_program = 'global_talents'
              case DigitalTransformation.sub_product_global_talent.index(sub_product)
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

          json['escolaridade'] = study_level

          case study_level
            when 'Ensino Superior', 'Mestrado', 'Doutorado'
              json['universidade'] = {item_id: DigitalTransformation.hash_universities_podio[university], value: university}
              json['curso'] = {item_id: DigitalTransformation.hash_courses_podio[course], value: course}
          end

          json['podio_status'] = 'lead_decidido'
          person.control_podio = json.to_json.to_s

          # escolaridade, universidade e curso
          json = if person.customized_fields.nil?
                   person.customized_fields = {}
                 else
                   JSON.parse(person.customized_fields)
                 end

          json['escolaridade'] = DigitalTransformation.study_level.index(study_level) - 1

          case study_level
            when 'Ensino Superior', 'Mestrado', 'Doutorado'
              json['universidade'] = DigitalTransformation.universities.index(university) - 1
              json['curso'] = DigitalTransformation.courses.index(course) - 1
          end
          person.customized_fields = json.to_json.to_s

          #como conheceu a AIESEC
          person.how_got_to_know_aiesec = DigitalTransformation.how_got_to_know_aiesec.index(how_got_to_know_aiesec) - 1

          person.save
          xp_sync = ExpaRdSync.new
          xp_sync.send_to_rd(person, nil, xp_sync.rd_identifiers[:open], nil)
          break
        end
      end
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