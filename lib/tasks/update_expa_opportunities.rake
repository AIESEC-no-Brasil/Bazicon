desc 'Updates ExpaOpportunity With Its Managers'
task :update_expa_opportunities => [ :environment ] do
  opportunities = ExpaOpportunity.all

  opportunities.each do |opportunity|
    data = EXPA::Opportunities.list_single_opportunity(opportunity.xp_id)

    managers = data['managers'] unless data['managers'].nil?

    if managers.any
      managers.each do |manager|
        # if ExpaManager.find_by(xp_id: manager.id)
        #   OpportunityManager.create(opportunity_id: opportunity.id, manager_id: manager_id_by_xp_id(manager.id))
        # else
        #   Opportunity.create(opportunity_id: opportunity.id, manager_id: create_expa_manager)
        # end
        puts "Manager: #{manager}"
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
