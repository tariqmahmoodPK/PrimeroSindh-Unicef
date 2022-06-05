# frozen_string_literal: true

require "#{Rails.root}/app/services/config_yaml_loader.rb"

email_settings = ConfigYamlLoader.load(Rails.root.join('config', 'mailers.yml'))

Rails.application.config.action_mailer.tap do |action_mailer|
  action_mailer.delivery_method = :smtp
  action_mailer.default_options = { from: 'noreply@septemsystems.com' }
  action_mailer.smtp_settings = {
    user_name: 'server35242',
    password: 'Mg68Aej2Q5YsBt9',
    address: 'smtp.socketlabs.com',
    port: 587,
    domain: 'cpims-ict.septemsystems.com',
    authentication: 'login',
    enable_starttls_auto: true
  }
  action_mailer.raise_delivery_errors = true
  action_mailer.perform_deliveries = true
end

ActionMailer::Base.default_url_options = {
  host: 'cpims-ict.septemsystems.com',
  protocol: 'https'
}
