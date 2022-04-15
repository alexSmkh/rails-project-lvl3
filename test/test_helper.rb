# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
  fixtures :all
end

module AuthConcernTest
  include AuthConcern

  def sign_in(user, _options = {})
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: user.email,
        name: user.name
      }
    }

    OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  include AuthConcernTest
end

class ActionDispatch::SystemTestCase
  include AuthConcernTest
end
