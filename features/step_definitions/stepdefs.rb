# frozen_string_literal: true

# @api private
module Helpers
  def config
    @agent.config
  end
end

World(Helpers)

After do
  @agent&.stop
end

Given('an agent') do
  # provided by World
end

Given('an application') do
  # provided by World
end

When('an api key is set to {string} in the config') do |api_key|
  config.api_key = api_key
end

Then('the Authorization header is {string}') do |auth_header|
  headers = ElasticAPM::Transport::Headers.new(config).to_h
  headers[:Authorization] == auth_header
end

When('an api key is set in the config') do
  config.api_key = '123:456'
end

Then('the api key is sent in the Authorization header') do
  headers = ElasticAPM::Transport::Headers.new(config).to_h
  headers[:Authorization].include?(config.api_key)
end

When('a secret_token is set in the config') do
  config.secret_token = 'abcde'
end

When('an api key is not set in the config') do
end

Then('the secret token is sent in the Authorization header') do
  headers = ElasticAPM::Transport::Headers.new(config).to_h
  headers[:Authorization].include?(config.secret_token)
end

When(%r{([/a-z0-9]+) is requested}) do |path|
  @response = get path
end

Then(%r{(\d+) metadatas? (is|are) sent}) do |count, *|
  wait_for metadatas: count
end

Then(%r{(\d+) transactions? (is|are) sent}) do |count, *|
  wait_for transactions: count
end

Then(%r{(\d+) spans? (is|are) sent}) do |count, *|
  wait_for spans: count
end
