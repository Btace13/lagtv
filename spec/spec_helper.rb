require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require "cancan/matchers"
  require 'database_cleaner'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  #FakeWeb.allow_net_connect = false
  FakeWeb.allow_net_connect = %r[^https?://gdata.youtube.com]

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
      FakeWeb.clean_registry
      Fabricate(:maximusblack_stream)
      Fabricate(:novawar_stream)
      Fabricate(:lagtv_stream, live: true)
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  ActiveSupport::Dependencies.clear
  ActiveRecord::Base.instantiate_observers
end