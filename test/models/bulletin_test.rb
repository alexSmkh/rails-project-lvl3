# frozen_string_literal: true

require 'test_helper'

class BulletinTest < ActiveSupport::TestCase
  setup do
    @bulletin = bulletins(:one)
  end

  test 'valid bulletin' do
    assert { @bulletin.valid? }
  end

  test 'invalid without title' do
    @bulletin.title = nil
    refute @bulletin.valid?
    assert_not_nil @bulletin.errors[:title]
  end

  test 'invalid without description' do
    @bulletin.description = nil
    refute @bulletin.valid?
    assert_not_nil @bulletin.errors[:description]
  end

  test 'invalid without category' do
    @bulletin.category = nil
    refute @bulletin.valid?
    assert_not_nil @bulletin.errors[:category]
  end

  test 'invalid without user' do
    @bulletin.user = nil
    refute @bulletin.valid?
    assert_not_nil @bulletin.errors[:user]
  end

  test 'invalid without image' do
    @bulletin.image = nil
    refute @bulletin.valid?
    assert_not_nil @bulletin.errors[:image]
  end

  test 'capitalizing title when updating' do
    title = 'title'
    @bulletin.title = title
    @bulletin.save

    assert { title.capitalize == @bulletin.title }
  end

  test 'capitalizing title when creating' do
    title = 'title'
    new_bulletin = Bulletin.new(
      title: title,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      user_id: users(:one).id,
      category_id: categories(:one).id
    )
    new_bulletin.image.attach(
      io: File.open(
        Rails.root.join('test', 'fixtures', 'files', 'two.png')
      ),
      filename: 'two.png'
    )
    new_bulletin.save

    assert { title.capitalize == new_bulletin.title }
  end
end
