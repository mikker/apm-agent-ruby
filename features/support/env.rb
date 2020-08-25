# frozen_string_literal: true

require 'cucumber/rspec/doubles'
require 'elastic-apm'

require 'rack/test'
require 'sinatra'
require 'webmock/cucumber'

require_relative '../../spec/support/mock_intake.rb'

class TestApp < Sinatra::Base
  use ElasticAPM::Middleware

  get '/' do
    'ok'
  end
end

class TestAppWorld
  include Rack::Test::Methods
  include MockIntake::WaitFor

  def initialize
    @mock_intake = MockIntake.stub!
    ElasticAPM.start(app: app, api_request_time: '250ms')
  end

  def app
    TestApp
  end
end

World do
  TestAppWorld.new
end
