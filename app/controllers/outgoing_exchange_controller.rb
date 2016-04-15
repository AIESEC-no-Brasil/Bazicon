class OutgoingExchangeController < ApplicationController

  # GET /ogx/dash
  def dash

  end

  # GET /ogx/list?lc=INTEGER&page=INTEGER&date_start=STRING&date_end=STRING
  def list
    prepare_expansor_expansions
    if params.include?('lc')
      lc_info_query = @expansor_expansions[params['lc']][1]
      if @user.list_programs == ExpaPerson.roles[:role_mc]
        lc_list_query = @expansor_expansions[params['lc']][1]
      elsif @user.xp_home_lc_id == @expansor_expansions[params['lc']][1]
        lc_list_query = @expansor_expansions[params['lc']][1]
      else
        lc_list_query = @expansor_expansions[0][1]
      end
    else
      lc_info_query = @expansor_expansions[0][1]
      lc_list_query = @expansor_expansions[0][1]
    end
    if params.include?('lc')
      page = params['page']
    else
      page = 0
    end
    if params.include?('date_start') && params.include?('date_end')
      date_start = DateTime.strptime(params['date_start'], '%d-%m-%y').to_time
      date_end = DateTime.strptime(params['date_end'], '%d-%m-%y').to_time
    else
      date_start = Time.new(Time.new.year, Time.new.month, 1)
      date_end = Time.new
    end

    prepare_information_list(lc_info_query)
    @people = filter_list_leads(lc_list_query,page, date_start, date_end)
  end

  # GET /ogx/detail
  def detail

  end

  private

  def prepare_information_list(search_lc_query)
    @info = {}

    @info['leads_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).count.to_f
    @info['leads_ogcdp_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).count.to_f
    @info['leads_ogip_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(interested_program: ExpaPerson.interested_programs[:global_talents]).count.to_f
    @info['leads_ogip_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(interested_program: ExpaPerson.interested_programs[:global_talents]).count.to_f
    @info['leads_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).count.to_f
    @info['leads_ogcdp_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).count.to_f
    @info['leads_ogip_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_talents]).count.to_f
    @info['leads_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).count.to_f
    @info['leads_ogcdp_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).count.to_f
    @info['leads_ogip_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_talents]).count.to_f

    @info['ma_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['ma_ogcdp_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['ma_ogip_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(interested_program: ExpaPerson.interested_programs[:global_talents]).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['ma_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['ma_ogcdp_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['ma_ogip_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_talents]).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['ma_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['ma_ogcdp_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['ma_ogip_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_talents]).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f

    @info['re_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['re_ogcdp_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['re_ogip_this_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month, 1)..Time.now).where(interested_program: ExpaPerson.interested_programs[:global_talents]).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['re_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['re_ogcdp_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['re_ogip_past_month'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year, Time.new.month - 1, 1)..(Time.new(Time.new.year, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_talents]).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['re_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['re_ogcdp_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['re_ogip_past_year'] = ExpaPerson.where(search_lc_query).where(xp_created_at: Time.new(Time.new.year - 1, Time.new.month - 1, 1)..(Time.new(Time.new.year - 1, Time.new.month, 1) - 1)).where(interested_program: ExpaPerson.interested_programs[:global_talents]).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f

    # Leads por semana esse mês total
    # Leads por dia esse mês total
    # Leads por semana esse mês oGCDP
    # Leads por dia esse mês oGCDP
    # Leads por semana esse mês oGIP
    # Leads por dia esse mês oGIP


    # MA por semana esse mês total
    # MA por dia esse mês total
    # MA por semana esse mês oGCDP
    # MA por dia esse mês oGCDP
    # MA por semana esse mês oGIP
    # MA por dia esse mês oGIP


    # RE por semana esse mês total
    # RE por dia esse mês total
    # RE por semana esse mês oGCDP
    # RE por dia esse mês oGCDP
    # RE por semana esse mês oGIP
    # RE por dia esse mês oGIP


    @info['ma_total'] = ExpaPerson.where(search_lc_query).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['re_total'] = ExpaPerson.where(search_lc_query).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['ma_ogcdp_total'] = ExpaPerson.where(search_lc_query).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['re_ogcdp_total'] = ExpaPerson.where(search_lc_query).where(interested_program: ExpaPerson.interested_programs[:global_volunteer]).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f
    @info['ma_ogip_total'] = ExpaPerson.where(search_lc_query).where(interested_program: ExpaPerson.interested_programs[:global_talents]).where(xp_status: ExpaPerson.xp_statuses[:matched]).count.to_f
    @info['re_ogip_total'] = ExpaPerson.where(search_lc_query).where(interested_program: ExpaPerson.interested_programs[:global_talents]).where(xp_status: ExpaPerson.xp_statuses[:realized]).count.to_f

    @info['ma_arab'] = 10.0
    @info['ma_east_europe'] = 10.0
    @info['ma_africa'] = 10.0
    @info['ma_asia'] = 10.0
    @info['ma_latam'] = 10.0
    @info['re_arab'] = 10.0
    @info['re_east_europe'] = 10.0
    @info['re_africa'] = 10.0
    @info['re_asia'] = 10.0
    @info['re_latam'] = 10.0
    @info['ma_start_up'] = 10.0
    @info['ma_educacional'] = 10.0
    @info['ma_it'] = 10.0
    @info['ma_management'] = 10.0
    @info['re_start_up'] = 10.0
    @info['re_educacional'] = 10.0
    @info['re_it'] = 10.0
    @info['re_management'] = 10.0

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
  end

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

  def filter_list_leads(search_lc_query, page, date_start, date_end)
    limit = 30
    @people = ExpaPerson.where(search_lc_query).where(xp_updated_at: date_start..date_end).order(xp_updated_at: :desc).limit(limit).offset(limit*page)
  end
end