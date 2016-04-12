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

    if EXPA.client.nil?
      expa = EXPA.setup()
    else
      expa = EXPA.client
    end

    expa.auth(user_name,password)
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

    if EXPA.client.nil?
      expa = EXPA.setup()
    else
      expa = EXPA.client
    end

    expa.auth(user_name,password)
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

  end

  # POST /expa/sign_up
  def expa_sign_up_success

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