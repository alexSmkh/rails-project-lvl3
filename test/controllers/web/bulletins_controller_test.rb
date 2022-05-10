# frozen_string_literal: true

require 'test_helper'
require 'securerandom'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    @bulletin_in_moderation = bulletins(:two)
    @category = categories(:one)
    @user = users(:one)
    sign_in @user
  end

  test 'should get index' do
    get bulletins_url
    assert_response :success
  end

  test 'user should get new' do
    get new_bulletin_url
    assert_response :success
  end

  test 'ser should create bulletin' do
    bulletin = {
      category_id: @category.id,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      title: Faker::Commerce.product_name.capitalize,
      image: fixture_file_upload('one.png', 'image/png')
    }

    post bulletins_path, params: { bulletin: bulletin }

    new_bulletin =
      Bulletin.find_by(
        title: bulletin[:title],
        description: bulletin[:description],
        category_id: @category.id
      )

    assert_redirected_to bulletin_path(new_bulletin)
    assert { new_bulletin.image.attached? }
    assert { new_bulletin }
  end

  test 'should show bulletin' do
    get bulletin_url(@bulletin)
    assert_response :success
  end

  test 'should not show bulletin if user is not creator/admin or bulletin state is not published' do
    get bulletin_path(@bulletin_in_moderation)

    assert_redirected_to root_path
  end

  test 'user should get edit' do
    get edit_bulletin_url(@bulletin)
    assert_response :success
  end

  test 'user should update bulletin' do
    updated_description = Faker::Lorem.paragraph(sentence_count: 5)
    updated_title = Faker::Commerce.product_name.capitalize
    category_id = categories(:two).id

    patch bulletin_path(@bulletin),
          params: {
            bulletin: {
              category_id: category_id,
              description: updated_description,
              title: updated_title
            }
          }

    assert_redirected_to bulletin_url(@bulletin)

    @bulletin.reload

    assert { @bulletin.title == updated_title }
    assert { @bulletin.description == updated_description }
    assert { @bulletin.category_id == category_id }
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
    get bulletins_path, params: {
      q: @bulletin.title
    }

    assert_response :success
  end
end
