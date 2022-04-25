# frozen_string_literal: true

require 'test_helper'

class CategoryPolicyTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @user = users(:one)
    @guest = nil
    @category = categories(:one)
  end

  test 'for an admin' do
    assert { Admin::CategoryPolicy.new(@admin, @category).new? }
    assert { Admin::CategoryPolicy.new(@admin, @category).create? }
    assert { Admin::CategoryPolicy.new(@admin, @category).edit? }
    assert { Admin::CategoryPolicy.new(@admin, @category).update? }
    assert { Admin::CategoryPolicy.new(@admin, @category).destroy? }
  end

  test 'for an user' do
    assert { !Admin::CategoryPolicy.new(@user, @category).new? }
    assert { !Admin::CategoryPolicy.new(@user, @category).create? }
    assert { !Admin::CategoryPolicy.new(@user, @category).edit? }
    assert { !Admin::CategoryPolicy.new(@user, @category).update? }
    assert { !Admin::CategoryPolicy.new(@user, @category).destroy? }
  end

  test 'for an guest' do
    assert { !Admin::CategoryPolicy.new(@guest, @category).new? }
    assert { !Admin::CategoryPolicy.new(@guest, @category).create? }
    assert { !Admin::CategoryPolicy.new(@guest, @category).edit? }
    assert { !Admin::CategoryPolicy.new(@guest, @category).update? }
    assert { !Admin::CategoryPolicy.new(@guest, @category).destroy? }
  end
end
