# frozen_string_literal: true

require 'test_helper'

# rubocop:disable Metrics/ClassLength
class BulletinTest < ActiveSupport::TestCase
  setup do
    @bulletin = bulletins(:one)
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
        Rails.root.join('test/fixtures/files/two.png')
      ),
      filename: 'two.png'
    )
    new_bulletin.save

    assert { title.capitalize == new_bulletin.title }
  end

  test 'default bulletin state' do
    bulletin = Bulletin.new

    assert_have_state bulletin, Bulletin::STATE_DRAFT
  end

  test 'draft state' do
    bulletin = Bulletin.new

    assert_event_allowed bulletin, :moderate
    assert_event_allowed bulletin, :archive
    refute_event_allowed bulletin, :publish
    refute_event_allowed bulletin, :reject

    assert_transitions_from bulletin,
                            Bulletin::STATE_DRAFT,
                            to: Bulletin::STATE_UNDER_MODERATION,
                            on_event: :moderate

    assert_transitions_from bulletin,
                            Bulletin::STATE_DRAFT,
                            to: Bulletin::STATE_ARCHIVED,
                            on_event: :archive
  end

  test 'under moderation state' do
    bulletin = Bulletin.new(state: Bulletin::STATE_UNDER_MODERATION)

    assert_event_allowed bulletin, :publish
    assert_event_allowed bulletin, :reject
    assert_event_allowed bulletin, :archive

    assert_transitions_from bulletin,
                            Bulletin::STATE_UNDER_MODERATION,
                            to: Bulletin::STATE_PUBLISHED,
                            on_event: :publish

    assert_transitions_from bulletin,
                            Bulletin::STATE_UNDER_MODERATION,
                            to: Bulletin::STATE_REJECTED,
                            on_event: :reject

    assert_transitions_from bulletin,
                            Bulletin::STATE_UNDER_MODERATION,
                            to: Bulletin::STATE_ARCHIVED,
                            on_event: :archive
  end

  test 'published state' do
    bulletin = Bulletin.new(state: Bulletin::STATE_PUBLISHED)

    assert_event_allowed bulletin, :archive
    refute_event_allowed bulletin, :reject
    refute_event_allowed bulletin, :moderate

    assert_transitions_from bulletin,
                            Bulletin::STATE_PUBLISHED,
                            to: Bulletin::STATE_ARCHIVED,
                            on_event: :archive
  end

  test 'rejected state' do
    bulletin = Bulletin.new(state: Bulletin::STATE_REJECTED)

    assert_event_allowed bulletin, :archive
    assert_event_allowed bulletin, :moderate
    refute_event_allowed bulletin, :publish

    assert_transitions_from bulletin,
                            Bulletin::STATE_REJECTED,
                            to: Bulletin::STATE_UNDER_MODERATION,
                            on_event: :moderate

    assert_transitions_from bulletin,
                            Bulletin::STATE_REJECTED,
                            to: Bulletin::STATE_ARCHIVED,
                            on_event: :archive
  end

  test 'archived state' do
    bulletin = Bulletin.new(state: Bulletin::STATE_ARCHIVED)

    refute_event_allowed bulletin, :publish
    refute_event_allowed bulletin, :moderate
    refute_event_allowed bulletin, :reject
  end
end
# rubocop:enable Metrics/ClassLength
