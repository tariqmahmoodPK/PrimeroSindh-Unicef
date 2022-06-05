# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start 'rails'
  SimpleCov.coverage_dir 'coverage/rspec'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'csv'
require 'active_support/inflector'
require 'sunspot_test/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

Mime::Type.register 'application/zip', :mock

ActiveJob::Base.queue_adapter = :test

module VerifyAndResetHelpers
  def verify(object)
    RSpec::Mocks.space.proxy_for(object).verify
  end

  def reset(object)
    RSpec::Mocks.space.proxy_for(object).reset
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include DateHelper
  config.include Devise::Test::IntegrationHelpers
  config.include FakeDeviseLogin
  config.include FakeLogin, type: :controller
  config.include VerifyAndResetHelpers
  config.include FilesTestHelper
  config.include ActiveSupport::Testing::TimeHelpers

  config.formatter = :progress

  # Provide clean nested contexts e.g.
  #
  # describe "..." do
  #   with "..." do
  #     it "..." do
  #       ...
  #     end
  #   end
  # end
  config.alias_example_group_to :with

  # Cleaner backtrace for failure messages
  config.backtrace_exclusion_patterns = [
    %r{/lib\d*/ruby/},
    %r{bin/},
    /gems/,
    %r{spec/spec_helper\.rb},
    %r{lib/rspec/(core|expectations|matchers|mocks)}
  ]
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #

  config.expect_with :rspec do |expectations|
    expectations.syntax = %i[should expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = %i[should expect]
    mocks.allow_message_expectations_on_nil = true
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true
  config.infer_spec_type_from_file_location!

  config.formatter = :progress

  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # Recreate db if needed.
  config.before(:suite) do
    FactoryBot.find_definitions
    if OptionsQueueStats.options_not_generated?
      SystemSettings.destroy_all && Location.destroy_all
      FactoryBot.create(:system_settings)
      FactoryBot.create(:location)
      GenerateLocationFilesJob.perform_now
    end
  end

  # Delete db if needed.
  config.after(:suite) do
  end

  config.after(:all) do
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  config.before(:each) { I18n.locale = I18n.default_locale = :en }
end

def stub_env(new_env)
  original_env = Rails.env
  Rails.instance_variable_set('@_env', ActiveSupport::StringInquirer.new(new_env))
  yield
ensure
  Rails.instance_variable_set('@_env', ActiveSupport::StringInquirer.new(original_env))
end

def clean_data(*models)
  models.each(&:destroy_all)
  SystemSettings.reset if models.include?(SystemSettings)
  Sunspot.commit if self.class.metadata&.dig(:search)
end

def reloaded_model(model)
  model.class.find(model.id)
end

def compute_checksum_in_chunks(io)
  Digest::MD5.new.tap do |checksum|
    while (chunk = io.read(5.megabytes))
      checksum << chunk
    end
    io.rewind
  end.base64digest
end
