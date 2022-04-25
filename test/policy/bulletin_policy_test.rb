# frozen_string_literal: true

require 'test_helper'

class BulletinPolicyTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @user = users(:one)
    @guest = nil
    @bulletin_created_by_user = bulletins(:one)
    @another_bulletin = bulletins(:two)
  end

  test 'for an admin' do
    assert { BulletinPolicy.new(@admin, @another_bulletin).new? }
    assert { BulletinPolicy.new(@admin, @another_bulletin).create? }
    assert { BulletinPolicy.new(@admin, @another_bulletin).edit? }
    assert { BulletinPolicy.new(@admin, @another_bulletin).update? }
    assert { BulletinPolicy.new(@admin, @another_bulletin).destroy? }
    assert { Admin::BulletinPolicy.new(@admin, Bulletin).index? }
  end

  test 'for an user' do
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).new? }
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).create? }
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).edit? }
    assert { !BulletinPolicy.new(@user, @another_bulletin).edit? }
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).update? }
    assert { !BulletinPolicy.new(@user, @another_bulletin).update? }
    assert { BulletinPolicy.new(@user, @bulletin_created_by_user).destroy? }
    assert { !BulletinPolicy.new(@user, @another_bulletin).destroy? }
    assert { !Admin::BulletinPolicy.new(@user, Bulletin).index? }
  end

  test 'for a guest' do
    refute BulletinPolicy.new(@guest, @another_bulletin).new?
    refute BulletinPolicy.new(@guest, @another_bulletin).create?
    refute BulletinPolicy.new(@guest, @another_bulletin).edit?
    refute BulletinPolicy.new(@guest, @another_bulletin).update?
    refute BulletinPolicy.new(@guest, @another_bulletin).destroy?
    refute Admin::BulletinPolicy.new(@guest, Bulletin).index?
  end
end
