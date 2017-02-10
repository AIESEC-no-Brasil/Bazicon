desc 'Updates ExpaOpportunity With Its Managers'
task :update_expa_opportunities do
  opportunities = ExpaOpportunity.all

  opportunities.each do |opportunity|
    # data = EXPA::Opportunity.single_opportunity_list_json({}, opportunity.xp_id)

    managers = data['managers'] unless data['managers'].nil?

    if managers.any
      managers.each do |manager|
        # if find manager by xp_id
          # opportunity_managers.create(opportunity_id, xp_id)
        # else
          # create manager
        # opportunity.managers.create(xp_id: manager['id'],
        #                             name: manager['name'],
        #                             email: manager['email'],
        #                             profile_photo_url: manager['profile_photo_url']
        #                           )
      end
    end
  end
end
