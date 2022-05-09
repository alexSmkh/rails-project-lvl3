# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  setup do
    @category = categories(:one)
  end

  test 'valid category' do
    assert { @category.valid? }
  end

  test 'invalid without name' do
    @category.name = nil
    assert_not @category.valid?
    assert_not_nil @category.errors[:name]
  end
end
