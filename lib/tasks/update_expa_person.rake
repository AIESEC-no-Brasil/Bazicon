desc 'Updates ExpaPerson With Its Managers'
task :update_expa_person => [ :environment ] do
  EXPA.setup.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])

  people = ExpaPerson.all

  people.each do |person|
    data = EXPA::People.list_single_person(person.xp_id)

    managers = []

    managers = data['managers'] unless data['managers'].nil?

    if managers.any?
      managers.each do |manager|
        unless ExpaPersonManager.find_by(expa_person_id: person.id, expa_manager_id: ExpaManager.id_by_xp_id(manager['id']))
          if ExpaManager.find_by(xp_id: manager['id'])
            expa_person_manager = ExpaPersonManager.create(expa_person_id: person.id,
                                                           expa_manager_id: ExpaManager.id_by_xp_id(manager['id'])
                                                          )

            puts "Person Manager created: #{expa_person_manager}"
          else
            expa_manager = ExpaManager.create(xp_id: manager['id'],
                                      name: manager['full_name'],
                                      email: manager['email'],
                                      profile_photo_url: manager['profile_photo_url']
                                    )

            puts "Manager created: #{expa_manager}"

            expa_person_manager = ExpaPersonManager.create(expa_person_id: person.id,
                                                           expa_manager_id: expa_manager.id
                                                          )

            puts "Person Manager created: #{expa_person_manager}"
          end
        else
          puts "Already created, skipping"
        end
      end
    end
  end
end
