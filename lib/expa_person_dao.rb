module ExpaPersonDAO
  class << self
    def number_of_leads(
        lc = ExpaPerson.find_by_xp_id(session[:expa_id]).xp_home_lc,
        date_range = (Time.now - 1)..Time.now)
      if lc.is_mc?
        ExpaPerson.where(xp_home_mc_id: lc.id).where(xp_created_at: date_range).count.to_f
      elsif lc.is_lc?
        ExpaPerson.where(xp_home_lc_id: lc.id).where(xp_created_at: date_range).count.to_f
      end
    end

    def number_of_leads_to_json(lc = ExpaPerson.find_by_xp_id(session[:expa_id]).xp_home_lc, date_range = (Time.now - 1)..Time.now)
      render json: number_of_leads(lc,date_range)
    end
  end
end