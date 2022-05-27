# frozen_string_literal: true

require 'test_helper'
require 'securerandom'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:draft)
    @category = categories(:one)
    @user = users(:one)
    sign_in @user
  end

  test 'should get index' do
    get bulletins_url
    assert_response :success
  end

  test 'should show bulletin' do
    get bulletin_url(@bulletin)

    assert_response :success
  end

  test 'user should get new' do
    get new_bulletin_url
    assert_response :success
  end

  test 'user should create bulletin' do
    bulletin = {
      category_id: @category.id,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      title: Faker::Commerce.product_name.capitalize,
      image: fixture_file_upload('one.png', 'image/png')
    }

    post bulletins_path, params: { bulletin: bulletin }

    new_bulletin = Bulletin.find_by(bulletin.except(:image))

    assert_redirected_to bulletin_path(new_bulletin)
    assert { new_bulletin }
  end

  test 'user should get edit' do
    get edit_bulletin_url(@bulletin)
    assert_response :success
  end

  test 'user should update bulletin' do
    edited_bulletin = {
      description: Faker::Lorem.paragraph(sentence_count: 5),
      title: Faker::Commerce.product_name,
      category_id: categories(:two).id
    }

    patch bulletin_path(@bulletin), params: { bulletin: edited_bulletin }

    assert_redirected_to bulletin_url(@bulletin)

    @bulletin.reload

    updated_bulletin = Bulletin.find_by(edited_bulletin.except(:image))

    assert { @bulletin.id == updated_bulletin.id }
  end

  test 'user should destroy bulletin' do
    delete bulletin_url @bulletin

    assert_nil Bulletin.find_by(id: @bulletin.id)
    assert_redirected_to root_path
  end

  test 'should send to the bulletin moderation' do
    patch moderate_bulletin_path(@bulletin)

    @bulletin.reload

    assert { @bulletin.aasm.current_state == Bulletin::STATE_UNDER_MODERATION }
    assert_redirected_to profile_path
  end

  test 'should archive bulletin' do
    patch archive_bulletin_path(@bulletin)

    @bulletin.reload

    assert { @bulletin.aasm.current_state == Bulletin::STATE_ARCHIVED }
    assert_redirected_to profile_path
  end

  test 'search bulletin' do
    get bulletins_path, params: { q: @bulletin.title }

    assert_response :success
  end
end
