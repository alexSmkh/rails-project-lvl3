# frozen_string_literal: true

require 'test_helper'

class BulletinPolicyTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @user = users(:one)
    @guest = nil
    @bulletin_created_by_user = bulletins(:one)
    @bulletin = bulletins(:two)
  end

  test 'for an admin' do
    assert { BulletinPolicy.new(@admin, @bulletin).new? }
    assert { BulletinPolicy.new(@admin, @bulletin).create? }
    assert { BulletinPolicy.new(@admin, @bulletin).edit? }
    assert { BulletinPolicy.new(@admin, @bulletin).update? }
    assert { BulletinPolicy.new(@admin, @bulletin).destroy? }
    assert { Admin::BulletinPolicy.new(@admin, Bulletin).index? }
    assert { Admin::BulletinPolicy.new(@admin, Bulletin).moderation? }
    assert { Admin::BulletinPolicy.new(@admin, @bulletin).reject? }
    assert { Admin::BulletinPolicy.new(@admin, @bulletin).publish? }
    assert { Admin::BulletinPolicy.new(@admin, @bulletin).archive? }
  end

  test 'for an user' do
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).new? }
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).create? }
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).edit? }
    assert { !BulletinPolicy.new(@user, @bulletin).edit? }
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).update? }
    assert { !BulletinPolicy.new(@user, @bulletin).update? }
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).destroy? }
    assert { !BulletinPolicy.new(@user, @bulletin).destroy? }
    assert { !Admin::BulletinPolicy.new(@user, Bulletin).index? }
    assert { !Admin::BulletinPolicy.new(@user, Bulletin).moderation? }
    assert { !Admin::BulletinPolicy.new(@user, @bulletin).reject? }
    assert { !Admin::BulletinPolicy.new(@user, @bulletin).publish? }
    assert { !Admin::BulletinPolicy.new(@user, @bulletin).archive? }
  end

  test 'for a guest' do
    refute BulletinPolicy.new(@guest, @bulletin).new?
    refute BulletinPolicy.new(@guest, @bulletin).create?
    refute BulletinPolicy.new(@guest, @bulletin).edit?
    refute BulletinPolicy.new(@guest, @bulletin).update?
    refute BulletinPolicy.new(@guest, @bulletin).destroy?
    refute Admin::BulletinPolicy.new(@guest, Bulletin).index?
    assert { !Admin::BulletinPolicy.new(@guest, Bulletin).moderation? }
    assert { !Admin::BulletinPolicy.new(@guest, @bulletin).reject? }
    assert { !Admin::BulletinPolicy.new(@guest, @bulletin).publish? }
    assert { !Admin::BulletinPolicy.new(@guest, @bulletin).archive? }
  end
end
