# Disruption
server 'ec2-52-9-139-17.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :db]

# Syncrhonization
server 'ec2-54-183-194-164.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :workers]

set :branch,        :master
