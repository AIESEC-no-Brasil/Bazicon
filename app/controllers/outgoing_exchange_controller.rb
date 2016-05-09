class OutgoingExchangeController < ApplicationController

  # GET /ogx/dash
  def dash

  end

  def list2
    render :json => {
        :name => 'Luan Corumba',
        :product => 'Teaching', 
        :date => '2:10 pm - 12.06.2014', 
        :status => 'open', 
        :dob => '25 anos',
        :email => 'luan.corumba@aiesec.net',
        :phone => '79 99999-9999',
        :city => 'Aracaju',
        :img => 'https://scontent-grt2-1.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/11012975_10153239647564758_7293399361939455419_n.jpg?oh=03d2f8ff6033a11e43405d5c2bfb67c0&oe=57B7CC3B'
      }
      
  end 

  # GET /ogx/list
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

  # GET /ogx/detail?id=INTEGER
  def detail
    return redirect_to main_path unless params.include?('id')

    EXPAHelper.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    @person = ExpaPerson.find_by_xp_id(params['id'])
    if @person.nil?
      return redirect_to main_path
    else
      begin
        @person.update_from_expa(EXPA::People.find_by_id(params['id']))
        @person.save
      rescue => exception
        puts exception
        return redirect_to main_path
      end
    end

    generate_program_product_array
    prepare_custom_fields(@person)
  end

  private

  def generate_program_product_array
    programs = DigitalTransformation.interested_program
    programs = programs[1,programs.size]

    gcdp = DigitalTransformation.sub_product_global_citizen
    gcdp = gcdp[1,gcdp.size]

    gip = DigitalTransformation.sub_product_global_talent
    gip = gcdp[1,gip.size]

    @program_product_array = [programs[0]].product(gcdp)+[programs[1]].product(gip)
  end

  def prepare_custom_fields(person)
    @custom_fields = {'nil' => nil}

    unless person.customized_fields.nil?
      keys = JSON.parse(person.customized_fields).keys
      keys.each do |key|
        if key == 'escolaridade' || key == 'universidade' || key == 'curso'
        elsif key == 'prevents' || key == 'difficulty'
          @custom_fields[key] = JSON.parse(person.customized_fields)[key]
        end
      end
    end
  end

  def prepare_information_list(search_lc_query)
    @info = {}

    sql_lc_query =
    if search_lc_query.keys.first == :xp_home_mc
      sql_lc_query = 'expa_people.xp_home_mc_id = ' + search_lc_query.values[0].id.to_s
    elsif search_lc_query.keys.first == :xp_home_lc
      sql_lc_query = 'expa_people.xp_home_lc_id = ' + search_lc_query.values[0].id.to_s
    elsif search_lc_query.keys.first == :entity_exchange_lc
      sql_lc_query = 'expa_people.entity_exchange_lc_id = ' + search_lc_query.values[0].id.to_s
    end

    this_year_string = "'#{Time.new(Time.new.year, 1, 1).strftime('%Y-%m-%d')}' AND '#{Time.now.strftime('%Y-%m-%d')}')"
    past_year_string = "'#{Time.new(Time.new.year - 1, 1, 1).strftime('%Y-%m-%d')}' AND '#{(Time.new(Time.new.year, 1, 1) - 1).strftime('%Y-%m-%d')}')"

    this_month_string = "'#{Time.new(Time.new.year, Time.new.month, 1).strftime('%Y-%m-%d')}' AND '#{Time.now.strftime('%Y-%m-%d')}')"
    past_month_string = "'#{Time.new(Time.new.year, Time.new.month-1, 1).strftime('%Y-%m-%d')}' AND '#{(Time.new(Time.new.year, Time.new.month, 1) - 1).strftime('%Y-%m-%d')}')"
    this_month_past_year_string = "'#{Time.new(Time.new.year - 1, Time.new.month, 1).strftime('%Y-%m-%d')}' AND '#{(Time.new(Time.new.year - 1, Time.new.month + 1, 1) -1).strftime('%Y-%m-%d')}')"

    sql_gcdp = "expa_opportunities.xp_programmes LIKE '%GCDP%'"
    sql_gip = "expa_opportunities.xp_programmes LIKE '%GIP%'"
    sql_ogx = "(expa_opportunities.xp_programmes LIKE '%GCDP%' OR expa_opportunities.xp_programmes LIKE '%GIP%')"

    sql_re = "(expa_applications.xp_current_status = 4 OR expa_applications.xp_status = 4)"
    sql_ma = "(expa_applications.xp_current_status = 3 OR expa_applications.xp_status = 3)"

    @info['leads_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_month_string).count.to_f
    @info['leads_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + past_month_string).count.to_f
    @info['leads_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_month_past_year_string).count.to_f

    @info['ip_ogcdp_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + "AND (expa_people.xp_created_at BETWEEN " + this_month_string + " AND expa_people.xp_status = 1 AND " + sql_gcdp).count
    @info['ip_ogcdp_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + "AND (expa_people.xp_created_at BETWEEN " + past_month_string + " AND expa_people.xp_status = 1 AND " + sql_gcdp).count.to_f
    @info['ip_ogcdp_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + "AND (expa_people.xp_created_at BETWEEN " + this_month_past_year_string + " AND expa_people.xp_status = 1 AND " + sql_gcdp).count.to_f

    @info['ip_ogip_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + "AND (expa_people.xp_created_at BETWEEN " + this_month_string + " AND expa_people.xp_status = 1 AND " + sql_gip).count
    @info['ip_ogip_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + "AND (expa_people.xp_created_at BETWEEN " + past_month_string + " AND expa_people.xp_status = 1 AND " + sql_gip).count.to_f
    @info['ip_ogip_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + "AND (expa_people.xp_created_at BETWEEN " + this_month_past_year_string + " AND expa_people.xp_status = 1 AND " + sql_gip).count.to_f

    @info['ma_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_ma + " AND " + sql_ogx).count.to_f
    @info['ma_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + past_month_string + " AND " + sql_ma + " AND " + sql_ogx).count.to_f
    @info['ma_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_past_year_string + " AND " + sql_ma + " AND " + sql_ogx).count.to_f

    @info['re_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_re + " AND " + sql_ogx).count.to_f
    @info['re_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + past_month_string + " AND " + sql_re + " AND " + sql_ogx).count.to_f
    @info['re_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_past_year_string + " AND " + sql_re + " AND " + sql_ogx).count.to_f

    @info['ma_ogcdp_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_ma + " AND " + sql_gcdp).count.to_f
    @info['ma_ogcdp_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + past_month_string + " AND " + sql_ma + " AND " + sql_gcdp).count.to_f
    @info['ma_ogcdp_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_past_year_string + " AND " + sql_ma + " AND " + sql_gcdp).count.to_f

    @info['ma_ogip_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_ma + " AND " + sql_gip).count.to_f
    @info['ma_ogip_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + past_month_string + " AND " + sql_ma + " AND " + sql_gip).count.to_f
    @info['ma_ogip_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_past_year_string + " AND " + sql_ma + " AND " + sql_gip).count.to_f

    @info['re_ogcdp_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_re + " AND " + sql_gcdp).count.to_f
    @info['re_ogcdp_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + past_month_string + " AND " + sql_re + " AND " + sql_gcdp).count.to_f
    @info['re_ogcdp_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_past_year_string + " AND " + sql_re + " AND " + sql_gcdp).count.to_f

    @info['re_ogip_this_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_re + " AND " + sql_gip).count.to_f
    @info['re_ogip_past_month'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + past_month_string + " AND " + sql_re + " AND " + sql_gip).count.to_f
    @info['re_ogip_past_year'] = ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_past_year_string + " AND " + sql_re + " AND " + sql_gip).count.to_f

    @info['leads_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_people.xp_created_at::timestamp)), COUNT (id) FROM expa_people WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_month_string + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['leads_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_people.xp_created_at::timestamp)), COUNT (id) FROM expa_people WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_month_string + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }

    @info['ip_ogcdp_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 1 AND " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_month_string + " AND " + sql_gcdp + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['ip_ogcdp_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 1 AND " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_month_string + " AND " + sql_gcdp + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['ip_ogip_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 1 AND " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_month_string + " AND " + sql_gip + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['ip_ogip_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 1 AND " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_month_string + " AND " + sql_gip + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }

    @info['ma_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_ogx + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['ma_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_ogx + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['ma_ogcdp_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_gcdp + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['ma_ogcdp_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_gcdp + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['ma_ogip_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_gip + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['ma_ogip_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_gip + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }

    @info['re_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_ogx + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['re_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_ogx + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['re_ogcdp_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_gcdp + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['re_ogcdp_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_gcdp + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['re_ogip_this_month_per_week'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('week', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_gip + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }
    @info['re_ogip_this_month_per_day'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('day', (expa_applications.xp_updated_at::timestamp)), COUNT (expa_applications.id) FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + this_month_string + " AND " + sql_gip + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| i.to_i }

    @info['ma_total'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 2 AND " + sql_ogx).count
    @info['re_total'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 3 AND " + sql_ogx).count

    @info['ma_ogcdp_total'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 2 AND " + sql_gcdp).count
    @info['re_ogcdp_total'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 3 AND " + sql_gcdp).count

    @info['ma_ogip_total'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 2 AND " + sql_gip).count
    @info['re_ogip_total'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE expa_people.xp_status = 3 AND " + sql_gip).count

    @info['ma_arab'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 0").count
    @info['ma_east_europe'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 1").count
    @info['ma_africa'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 2").count
    @info['ma_asia'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 3").count
    @info['ma_latam'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 4").count
    @info['ma_start_up'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 5").count
    @info['ma_educacional'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 6").count
    @info['ma_it'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 7").count
    @info['ma_management'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_ma + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 8").count\

    @info['re_arab'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 0").count
    @info['re_east_europe'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 1").count
    @info['re_africa'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 2").count
    @info['re_asia'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 3").count
    @info['re_latam'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 4").count
    @info['re_start_up'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 5").count
    @info['re_educacional'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 6").count
    @info['re_it'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 7").count
    @info['re_management'] = ActiveRecord::Base.connection.execute("SELECT expa_people.* FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_re + " AND " + sql_gcdp + "AND expa_people.interested_sub_product = 8").count


    @info['leads_this_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_year_string + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['ma_this_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_year_string + " AND " + sql_ogx + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['ma_ogcdp_this_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_year_string + " AND " + sql_gcdp + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['ma_ogip_this_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_year_string + " AND " + sql_gip + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['re_this_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_year_string + " AND " + sql_ogx + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['re_ogcdp_this_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_year_string + " AND " + sql_gcdp + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['re_ogip_this_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + this_year_string + " AND " + sql_gip + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }

    @info['leads_last_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + past_year_string + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['ma_last_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + past_year_string + " AND " + sql_ogx + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['ma_ogcdp_last_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + past_year_string + " AND " + sql_gcdp + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['ma_ogip_last_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + past_year_string + " AND " + sql_gip + " AND " + sql_ma + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['re_last_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + past_year_string + " AND " + sql_ogx + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['re_ogcdp_last_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + past_year_string + " AND " + sql_gcdp + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }
    @info['re_ogip_last_year_per_month'] = ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('month', (expa_people.xp_created_at::timestamp)), COUNT (expa_people.id) FROM expa_people INNER JOIN expa_applications ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_people.xp_created_at BETWEEN " + past_year_string + " AND " + sql_gip + " AND " + sql_re + " GROUP BY 1 ORDER BY 1 ASC").values.map { |x,i| [i] }.each_with_index.map { |x,i| [i+1,x.first.to_i] }

    @info.each do |k,v|
      @info[k] = (v == 0) ? 1 : v
    end
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