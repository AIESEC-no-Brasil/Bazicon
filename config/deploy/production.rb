# App 001
server 'ec2-54-219-169-33.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :db]

# Sync
server 'ec2-54-183-197-1.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :workers, :clock]

set :branch,        :master
