# App
server 'ec2-54-215-232-152.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :db]

# Sync
server 'ec2-54-183-194-164.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :workers, :clock]

set :branch,        :dev
