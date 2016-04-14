class OutgoingExchangeController < ApplicationController

  # GET /ogx/dash
  def dash

  end

  # GET /ogx/list?lc=INTEGER
  def list
    prepare_expansor_expansions
    if params.include?('lc')
      search_lc_query = @expansor_expansions[params['lc']][1]
    else
      search_lc_query = @expansor_expansions[0][1]
    end

    @info = {}

    # Leads total esse mês
    @info['leads_total'] = ExpaPerson.where(search_lc_query, xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).count
    # Leads oGCDP esse mês
    @info['leads_ogcdp_total'] = ExpaPerson.where(search_lc_query, xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now, interested_program: ExpaPerson.interested_programs[:global_volunteer]).count
    # Leads oGIP esse mês
    @info['leads_ogip_total'] = ExpaPerson.where(search_lc_query, xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now, interested_program: ExpaPerson.interested_programs[:global_talents]).count
    # Leads por semana esse mês total
    # Leads por dia esse mês total
    # Leads por semana esse mês oGCDP
    # Leads por dia esse mês oGCDP
    # Leads por semana esse mês oGIP
    # Leads por dia esse mês oGIP

    # MA total esse mês
    # MA oGCDP esse mês
    # MA oGIP esse mês
    # MA por semana esse mês total
    # MA por dia esse mês total
    # MA por semana esse mês oGCDP
    # MA por dia esse mês oGCDP
    # MA por semana esse mês oGIP
    # MA por dia esse mês oGIP

    # RE total esse mês
    # RE oGCDP esse mês
    # RE oGIP esse mês
    # RE por semana esse mês total
    # RE por dia esse mês total
    # RE por semana esse mês oGCDP
    # RE por dia esse mês oGCDP
    # RE por semana esse mês oGIP
    # RE por dia esse mês oGIP

    # Leads total mês passado
    @info['leads_total_past_month'] = ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1))
    # Leads oGCDP mês passado
    @info['leads_ogcdp_past_month'] = ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1), interested_program: ExpaPerson.interested_programs[:global_volunteer])
    # Leads oGIP mês passado
    ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1), interested_program: ExpaPerson.interested_programs[:global_talents])
    # MA oGCDP mês passado
    # MA oGIP mês passado
    # RE oGCDP mês passado
    # RE oGIP mês passado

    # Leads total ano/mês passado
    ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1))
    # Leads oGCDP ano/mês passado
    ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1), interested_program: ExpaPerson.interested_programs[:global_volunteer])
    # Leads oGIP ano/mês passado
    ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1), interested_program: ExpaPerson.interested_programs[:global_talents])
    # MA oGCDP ano/mês passado
    # MA oGIP ano/mês passado
    # RE oGCDP ano/mês passado
    # RE oGIP ano/mês passado

    # EP MA total oGCDP
    # EP RE total oGCDP
    # EP MA total oGIP
    # EP RE total oGIP

    # Numero Lead por mes esse ano total
    for i in 1..Time.new.month
      ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year, i, 1)..Time.new)
    end
    # Numero Lead por mes esse ano oGCDP
    for i in 1..Time.new.month
      ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year, i, 1)..Time.new, interested_program: ExpaPerson.interested_programs[:global_volunteer])
    end
    # Numero Lead por mes esse ano oGIP
    for i in 1..Time.new.month
      ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year, i, 1)..Time.new, interested_program: ExpaPerson.interested_programs[:global_talents])
    end

    # Numero MA por mes esse ano total
    # Numero MA por mes esse ano oGCDP
    # Numero MA por mes esse ano oGIP
    # Numero RE por mes esse ano total
    # Numero RE por mes esse ano oGCDP
    # Numero RE por mes esse ano oGIP


    # Numero Lead por mes ano passado total
    for i in 1..12
      ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year - 1, i, 1)..Time.new)
    end
    # Numero Lead por mes ano passado oGCDP
    for i in 1..12
      ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year - 1, i, 1)..Time.new, interested_program: ExpaPerson.interested_programs[:global_volunteer])
    end
    # Numero Lead por mes ano passado oGIP
    for i in 1..12
      ExpaPerson.count(search_lc_query, xp_created_at: Time.new(Time.new.year - 1, i, 1)..Time.new, interested_program: ExpaPerson.interested_programs[:global_talents])
    end
    # Numero MA por mes ano passado total
    # Numero MA por mes ano passado oGCDP
    # Numero MA por mes ano passado oGIP
    # Numero RE por mes ano passado total
    # Numero RE por mes ano passado oGCDP
    # Numero RE por mes ano passado oGIP

    @people = filter_list_leads
  end

  # GET /ogx/detail
  def detail

  end

  private

  def prepare_expansor_expansions
    @expansor_expansions = []

    expansor_expansions = []
    offices = ExpaOffice.where(xp_id: @user.xp_home_lc.xp_id)
    offices.each do |office|
      expansor_expansions << office.xp_name
    end

    text = ''
    expansor_expansions.each do |entity|
      if text == ''
        text = entity
      else
        text = text + ' + ' + entity
      end
    end

    if @user.get_role == ExpaPerson.roles[:role_mc]
      @expansor_expansions << ['MC', xp_home_mc: @user.xp_home_mc]
      @expansor_expansions << ['--', xp_home_mc: @user.xp_home_mc]
    else
      @expansor_expansions << [text, xp_home_lc: @user.xp_home_lc]
    end



    expansor_expansions.each do |entity|
      @expansor_expansions << [entity, entity_exchange_lc: DigitalTransformation.hash_entities_expa[entity]]
    end

    @expansor_expansions << ['--', xp_home_lc: @user.xp_home_lc]


    hash_entities_expa = DigitalTransformation.hash_entities_expa
    hash_entities_expa.delete('nil')
    hash_entities_expa.delete('Comitê Local')
    entities = []
    hash_entities_expa.keys.each do |entity|
      unless expansor_expansions.include?(entity)
        expa_id = hash_entities_expa[entity]
        unless expa_id.nil?
          text = ''
          hash_entities_expa.keys.each do |temp|
            if expa_id == hash_entities_expa[temp]
              if text == ''
                text = temp
              else
                text = text + ' + ' + temp
              end
            end
          end
          entities << [text, xp_home_lc_id: expa_id]
        end
      end
    end

    @expansor_expansions += entities
  end

  def filter_list_leads
    @people
  end
end