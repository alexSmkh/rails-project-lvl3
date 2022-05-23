# frozen_string_literal: true

require 'test_helper'

class BulletinTest < ActiveSupport::TestCase
  setup do
    @bulletin = bulletins(:draft)
  end

  test 'valid bulletin' do
    assert { @bulletin.valid? }
  end

  test 'invalid without title' do
    @bulletin.title = nil
    assert_not @bulletin.valid?
    assert_not_nil @bulletin.errors[:title]
  end

  test 'invalid without description' do
    @bulletin.description = nil
    assert_not @bulletin.valid?
    assert_not_nil @bulletin.errors[:description]
  end

  test 'invalid without category' do
    @bulletin.category = nil
    assert_not @bulletin.valid?
    assert_not_nil @bulletin.errors[:category]
  end

  test 'invalid without user' do
    @bulletin.user = nil
    assert_not @bulletin.valid?
    assert_not_nil @bulletin.errors[:user]
  end

  test 'invalid without image' do
    @bulletin.image = nil
    assert_not @bulletin.valid?
    assert_not_nil @bulletin.errors[:image]
  end
end
