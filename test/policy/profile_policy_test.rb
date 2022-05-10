# frozen_string_literal: true

require 'test_helper'

class ProfilePolicyTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @guest = nil
  end

  test 'for an user' do
    assert { Profile::BulletinPolicy.new(@user, Bulletin).index? }
  end

  test 'for a guest' do
    assert_not Profile::BulletinPolicy.new(@guest, Bulletin).index?
  end
end
