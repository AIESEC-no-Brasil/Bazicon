# Bazicon

## Project Configurations

### Initial Setup & Vagrant

> Copy the file `local_env.yml` to the `config` directory within app

#### Copy the database configuration file

`$ cp config/database.example.yml config/database.yml`

#### Run vagrantfile

`$ vagrant up`

> This proccess will setup your Ruby & Postgres environment all set to run a Rails project

#### Access Vagrant through SSH

`$ vagrant ssh`

### Once within the Virtual Machine:

#### Access the shared directory mirroring the application's files

`$ cd /vagrant/`

#### Install gems and dependencies from Gemfile

`$ bundle install`

#### Create and migrate the database

`$ rails db:create db:migrate`

> For further accesses, if any changes have been made in the database just migrate to the new version:  `rails db:migrate`

#### Execute the desired Rails' processes:

- `rails s -b 0.0.0.0`: Initializes the webserver binding to the address `0.0.0.0` and port `3000` (default) serving the application (http://localhost:3000)

- `rails c`: Initializes the rails console with database access (development environment by default)

- `bundle exec shoryuken -R -C config/shoryuken.yml`: Executes the Shoryuken gem monitor that handles the SQS management

## Environment Variables

### AWS Access Credentials

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION

### Slack Notifications

- SLACK_WEBHOOK_URL
