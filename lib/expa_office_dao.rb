module ExpaOfficeDAO
  class << self
    def list_lcs_by_user_xp_id(xp_id)
      person = ExpaPerson.find_by_xp_id(xp_id)

      if person.nil?
        person = ExpaPerson.new
        person.update_from_expa(EXPA::People.find_by_id(xp_id))
        person.save
      end

      if person.get_role == ExpaPerson.roles[:role_mc]
        zxc = [ExpaOffice.find_by_id(person.xp_home_mc_id)]
        offices = ExpaOffice.joins(:people_on_home_lc).where(expa_people: {xp_home_mc_id: person.xp_home_mc_id}).group(:id).order(:xp_name).to_a
        offices = offices.group_by{ |x| x.xp_id }
        offices.each_with_index { |x,i| zxc << x[1].first}
        offices = zxc
      else
        offices = ExpaOffice.where(xp_id: person.xp_home_lc.xp_id).order(name: :desc).to_a
        offices = offices.group_by{ |x| x.xp_id }
        offices.each_with_index { |x,i| zxc << x[1].first}
        offices = zxc
      end

      offices
    end

    def list_lcs_by_user_xp_id_to_json(xp_id)
      render json: list_lcs_by_user_xp_id(xp_id)
    end
  end
end