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
    refute @category.valid?
    assert_not_nil @category.errors[:name]
  end

  test 'capitalizing name when creating' do
    name = 'name'
    new_category = Category.create(name: name)
    assert { new_category.name == name.capitalize }
  end
end
