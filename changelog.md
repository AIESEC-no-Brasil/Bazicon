# Change log

## Mar 13th 2017

### General

- Opportunities have been update in Production with its new database structure (Ongoing)

- EP have been updated in Production with its new database structure (Ongoing)

### Mailgun

- Mailgun now shoots mails for Opportunity Managers & EP Managers

### Services & Jobs

- UpdateStatus job now triggers mailgun upon status changing so it communicates its opportunity/ep managers

- Whenever a new opportunity or EP data is grabbed from the API it also comes with manager data from now on

### ExpaRb

- Adds EP Managers data handling through API

### Hotfixes

- Shoryuken error prone job handling tweaked, now outputs better information

- Checkbox disappearence in sign up forms now corrected

## Feb 12th 2017

### General

- Application now uses Capistrano to handle deployment tasks, which is a more reliable way of dealing with so

- Spring is now enabled and application has been _springfied_ to increase performance on daily development tasks

- Sentry has been verified to work properly and is tracking any source errors

### Servers & Infrastructure

- A QA instance is now available for hands on testing purposes

- QA instance is continuosly deployed

- New production servers instances are now available replacing old ones

- CircleCI has been added as the general purpose continuos integration tool for the application

### Mailer

- Mailgun integration now available through a service that mails any given data

### Vagrant

- Performance tweaks for vagrant, which includes better filesystem handling and increased virtual memory shared from host machine

### ExpaRb

- Adds Opportunities' managers data handling from API

### Hotfixes

- Minor fix removes send_to_od's call from crontab as it's no longer used

- Vagrant now installs RVM through a more convenient way fixing permission errors while trying to bundle install and/or update

## Jan 16th 2017

### General

- Added Sentry support
- Improved README
- Refactored SYNC lib

### Workers

- Added Jobs Worker
- Message comsuption for jobs worker
- Added Jobs SQS
