# Bazicon

## Project Configurations

### Initial Setup & Vagrant (Development Environment)

> Copy the file `local_env.yml` or create your own to the `config` directory within app

#### Copy the database configuration file

`$ cp config/database.example.yml config/database.yml`

#### Run vagrantfile

`$ vagrant up`

> This proccess will setup your Ruby & Postgres environment all set to run a Rails project

#### Access Vagrant through SSH

`$ vagrant ssh`

### Once within the Virtual Machine:

#### Install gems and dependencies from Gemfile

`$ bundle install`

#### Create and migrate the database

`$ rails db:create db:migrate`

> For further accesses, if any changes have been made in the database just migrate to the new version:  `rails db:migrate`

#### Execute the desired Rails' processes:

- `rails s -b 0.0.0.0`: Initializes the webserver binding to the address `0.0.0.0` and port `3000` (default) serving the application (http://localhost:3000)

- `rails c`: Initializes the rails console with database access (development environment by default)

- `bundle exec shoryuken -R -C config/shoryuken.yml -d -L /path/to/logfile`: Executes the Shoryuken gem monitor as a daemon that handles the SQS management

## Environment Variables

### AWS Access Credentials

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION

### Slack Notifications

- SLACK_WEBHOOK_URL

### RDStation

- RD_STATION_URL: 'https://www.rdstation.com.br/api/1.3/conversions'
- RD_STATION_TOKEN
- RD_STATION_PRIVATE_TOKEN

### DROPBOX

- DROPBOX_TOKEN
- DROPBOX_SECRET

### ROBOZINHO

- ROBOZINHO_EMAIL
- ROBOZINHO_PASSWORD
- SIMPLE_TOKEN_EMAIL
- SIMPLE_TOKEN_PASSWORD

### DATABASE

- DEVELOPMENT_UNICODE
- DEVELOPMENT_DATABASE
- DEVELOPMENT_USERNAME
- DEVELOPMENT_PASSWORD
- DEVELOPMENT_HOST
- DEVELOPMENT_POST

- TEST_UNICODE
- TEST_DATABASE
- TEST_USERNAME
- TEST_PASSWORD
- TEST_HOST
- TEST_POST

- PRODUCTION_UNICODE
- PRODUCTION_DATABASE
- PRODUCTION_USERNAME
- PRODUCTION_PASSWORD
- PRODUCTION_HOST
- PRODUCTION_POST

### PODIO

- PODIO_USERNAME
- PODIO_PASSWORD
- PODIO_2_USERNAME
- PODIO_2_PASSWORD
- PODIO_API_KEY
- PODIO_API_SECRET

### RAILS

- SECRET_KEY_BASE
