# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Leads = Host.create([{full_name: "Lead 1"}])
tags = Tag.create([{ name: 'TM' }, { name: 'ICX' },{ name: 'OGX' },{ name: 'GCDP' },{ name: 'GIP' }, { name: 'FIN' },
                   { name: 'MKT' },{ name: 'OUTPUT' },{ name: 'APRESENTAÇÃO' },{name: 'TREINAMENTO' },
                   {name: 'FERRAMENTA'}, {name: 'RELATÒRIO'}   ])


(1..15).each do |f|
	free = HostPerson.new
	free.full_name = "Free #{f}"
	free.date_approach = Time.new(2016,4,21)
	free.save
end