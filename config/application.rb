require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Myapp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = "pt-BR"

    I18n.config.enforce_available_locales = false

    config.assets.enabled = true
    config.encoding = 'utf-8'

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.assets.precompile += [ 'appviews.css', 'archives.css', 'cssanimations.css', 'dashboards.css', 'digital_transformation.css', 'forms.css', 'gallery.css', 'graphs.css', 'mailbox.css', 'miscellaneous.css', 'outgoing_exchange.css', 'pages.css', 'tables.css', 'uielements.css', 'widgets.css', 'files.css' ]
    config.assets.precompile += [ 'appviews.js',  'archives.js', 'cssanimations.js', 'dashboards.js', 'digital_transformation.js', 'forms.js', 'gallery.js', 'graphs.js', 'mailbox.js', 'miscellaneous.js', 'outgoing_exchange.js', 'pages.js', 'tables.js', 'uielements.js', 'widgets.js', 'files.js' ]
    #config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths << "#{Rails.root}/lib"
    config.eager_load_paths << "#{Rails.root}/lib"

    Raven.configure do |config|
      config.dsn = 'https://d2e499a95bdc478aacc84491f365a9f6:88bc3b8e4eff404bb7b6de2a5eac773d@sentry.io/129061'
      config.environments = %w[production]
    end
  end
end
