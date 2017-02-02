# App
server 'ec2-54-215-232-152.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :db]

# Sync
server 'ec2-52-53-207-238.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :workers, :clock]

set :branch,        :dev
