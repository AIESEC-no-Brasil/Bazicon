module ExpaApplicationDAO
  class << self
    #TODO adapt to ActiveRecord on Rails 5. Rails 5 have "OR"
    def number_of_ma(
        lc = ExpaPerson.find_by_xp_id(session[:expa_id]).xp_home_lc,
        date_range = (Time.now - 1)..Time.now)

      if lc.is_mc?
        sql_lc_query = 'expa_people.xp_home_mc_id = ' + lc.id.to_s
      elsif lc.is_lc?
        sql_lc_query = 'expa_people.entity_exchange_lc_id = ' + lc.id.to_s
      end

      time = "'#{date_range.begin.strftime('%Y-%m-%d')}' AND '#{date_range.end.strftime('%Y-%m-%d')}')"
      sql_ma = "(expa_applications.xp_current_status = 3 OR expa_applications.xp_status = 3)"
      sql_ogx = "(expa_opportunities.xp_programmes LIKE '%GCDP%' OR expa_opportunities.xp_programmes LIKE '%GIP%')"

      ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + time + " AND " + sql_ma + " AND " + sql_ogx).count.to_f
    end

    def number_of_re(
        lc = ExpaPerson.find_by_xp_id(session[:expa_id]).xp_home_lc,
        date_range = (Time.now - 1)..Time.now)

      if lc.is_mc?
        sql_lc_query = 'expa_people.xp_home_mc_id = ' + lc.id.to_s
      elsif lc.is_lc?
        sql_lc_query = 'expa_people.entity_exchange_lc_id = ' + lc.id.to_s
      end

      time = "'#{date_range.begin.strftime('%Y-%m-%d')}' AND '#{date_range.end.strftime('%Y-%m-%d')}')"
      sql_re = "(expa_applications.xp_current_status = 4 OR expa_applications.xp_status = 4)"
      sql_ogx = "(expa_opportunities.xp_programmes LIKE '%GCDP%' OR expa_opportunities.xp_programmes LIKE '%GIP%')"

      ActiveRecord::Base.connection.execute("SELECT expa_applications.* FROM expa_applications INNER JOIN expa_people ON expa_applications.xp_person_id = expa_people.xp_id INNER JOIN expa_opportunities ON expa_applications.xp_opportunity_id = expa_opportunities.id WHERE " + sql_lc_query + " AND (expa_applications.xp_updated_at BETWEEN " + time + " AND " + sql_re + " AND " + sql_ogx).count.to_f
    end

    def number_of_ma_to_json(lc = ExpaPerson.find_by_xp_id(session[:expa_id]).xp_home_lc, date_range = (Time.now - 1)..Time.now)
      render json: number_of_ma(lc, date_range)
    end

    def number_of_re_to_json(lc = ExpaPerson.find_by_xp_id(session[:expa_id]).xp_home_lc, date_range = (Time.now - 1)..Time.now)
      render json: number_of_re(lc, date_range)
    end
  end
end