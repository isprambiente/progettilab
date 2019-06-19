require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Progettilab
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.encoding = 'utf-8'
    config.i18n.default_locale = :it
    config.time_zone = 'Rome'
    config.generators do |g|
      g.template_engine :haml
    end
    config.autoload_paths += %W( #{config.root}/app/reports/pdfs )

    config.assets.paths << Rails.root.join("app", "assets", "javascripts", "datatables")
  end
end
