# Bazicon

## Configurações do Projeto

### Configurações Iniciais & Vagrant

> Copiar o arquivo `local_env.yml` para o diretório `config` do projeto

#### Copiar o arquivo de configuração dos bancos de dados

`$ cp config/database.example.yml config/database.yml`

#### Rodar o vagrantfile

`$ vagrant up`

> Este processo preparará o ambiente Ruby & Postgres pronto para rodar um projeto Rails

#### Acessar o vagrant via SSH

`$ vagrant ssh`

### Uma Vez Dentro da Máquina Virtual:

#### Acessar o diretório compartilhado dentro da máquina virtual contendo os arquivos da aplicação

`$ cd /vagrant/`

#### Instalar as gems e dependências contidas no Gemfile

`$ bundle install`

#### Criar e migrar os bancos de dados

`$ rails db:create db:migrate`

> Para acessos posteriores, se houver alguma mudança no banco de dados apenas migrar para a versão nova: `rails db:migrate`

#### Executar os Processos Rails Desejados:

- `rails s -b 0.0.0.0`: Inicializa o webserver atrelado ao endereço `0.0.0.0` e porta `3000` (padrão) para servir a aplicação rails (http://localhost:3000)

- `rails c`: Inicializa o console rails com acesso ao banco de dados (por padrão no ambiente de desenvolvimento)

- `bundle exec shoryuken -r worker.rb -C shoryuken.yml`: Executa o monitor da gem Shoryuken responsável por gerenciar o serviço SQS

## Variáveis de Ambiente

### Credenciais de Acesso AWS

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
