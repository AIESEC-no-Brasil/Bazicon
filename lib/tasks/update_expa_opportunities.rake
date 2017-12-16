desc 'Updates ExpaOpportunity With Its Managers'
task :update_expa_opportunities => [ :environment ] do
  EXPA.setup.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])

  opportunities = ExpaOpportunity.where(has_been_migrated: false).includes(:expa_opportunity_managers).where(expa_opportunity_managers: { expa_opportunity_id: nil })

  puts "#{opportunities.count} Opportunities"

  opportunities.each do |opportunity|
    puts "Opportunity: #{opportunity}"

    data = EXPA::Opportunities.list_single_opportunity(opportunity.xp_id)

    puts "Data: #{data}"

    managers = []

    managers = data['managers'] unless data['managers'].nil?

    puts "Managers: #{managers}"

    if managers.any?
      managers.each do |manager|

        puts "Manager: #{manager}"
        puts "Opportunity: #{opportunity}"

        unless ExpaOpportunityManager.find_by(expa_opportunity_id: opportunity.id, expa_manager_id: ExpaManager.id_by_xp_id(manager['id']))
          if ExpaManager.find_by(xp_id: manager['id'])
            expa_opportunity_manager = ExpaOpportunityManager.create(expa_opportunity_id: opportunity.id,
                                                                     expa_manager_id: ExpaManager.id_by_xp_id(manager['id'])
                                                                    )

            puts "Opportunity Manager created: #{expa_opportunity_manager}"
          else
            expa_manager = ExpaManager.create(xp_id: manager['id'],
                                      name: manager['full_name'],
                                      email: manager['email'],
                                      profile_photo_url: manager['profile_photo_url']
                                    )

            puts "Manager created: #{expa_manager}"

            expa_opportunity_manager = ExpaOpportunityManager.create(expa_opportunity_id: opportunity.id,
                                                                     expa_manager_id: expa_manager.id
                                                                    )

            puts "Opportunity Manager created: #{expa_opportunity_manager}"
          end
        else
          puts "Already created, skipping"
        end
      end
    end

  opportunity.update(has_been_migrated: true)
  end
end
