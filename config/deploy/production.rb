# App
server 'ec2-52-8-184-67.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :db]
server 'ec2-54-215-251-199.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :db]
server 'ec2-54-183-99-215.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :db]
server 'ec2-54-193-73-144.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :db]

# Sync
server 'ec2-54-183-197-1.us-west-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: [:web, :app, :workers, :clock]

set :branch,        :master
