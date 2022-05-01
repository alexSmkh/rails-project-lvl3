# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  # rubocop:disable Style/FetchEnvVar
  provider :github,
           ENV['GITHUB_CLIENT_ID'],
           ENV['GITHUB_CLIENT_SECRET'],
           scope: 'user'
  # rubocop:enable Style/FetchEnvVar
end
