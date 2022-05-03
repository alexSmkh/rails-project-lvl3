# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'aasm/minitest'

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
  fixtures :all
end

class ActionDispatch::IntegrationTest
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
  end
end

class ActionDispatch::SystemTestCase
  include AuthConcern
  include ActionView::Helpers::DateHelper

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

    visit callback_auth_url('github')
  end

  def posted_by(bulletin)
    safe_join(
      [
        content_tag(:span, t('posted_by'), class: 'me-1'),
        content_tag(:span, bulletin.user.name, class: 'fst-italic text-secondary fw-bolder me-1'),
        content_tag(:span, "#{time_ago_in_words(bulletin.created_at)} ago")
      ]
    )
  end
end
