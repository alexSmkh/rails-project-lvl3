# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test 'valid user' do
    assert { @user.valid? }
  end

  test 'invalid user without name' do
    @user.name = nil
    assert_not @user.valid?
    assert_not_nil @user.errors[:name]
  end

  test 'invalid user without email' do
    @user.email = nil
    assert_not @user.valid?
    assert_not_nil @user.errors[:email]
  end
end
