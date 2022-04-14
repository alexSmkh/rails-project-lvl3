# frozen_string_literal: true

require 'test_helper'
require 'securerandom'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    @category = categories(:one)
    @user = users(:one)
  end

  test 'should get index' do
    get bulletins_url
    assert_response :success
  end

  test 'signed user should get new' do
    sign_in @user
    get new_bulletin_url
    assert_response :success
  end

  test 'unauth user should not get new' do
    get new_bulletin_url
    assert_redirected_to root_path
  end

  test 'signed user should create bulletin' do
    sign_in @user

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

  test 'unauth user should not create bulletin' do
    title = 'Title'
    post bulletins_path,
         params: {
           bulletin: {
             category_id: @category.id,
             description: Faker::Lorem.paragraph(sentence_count: 5),
             title: title,
             image: fixture_file_upload('one.png', 'image/png')
           }
         }

    assert_nil Bulletin.find_by(title: title)
    assert_redirected_to root_path
  end

  test 'should show bulletin' do
    get bulletin_url(@bulletin)
    assert_response :success
  end

  test 'signed user should get edit' do
    sign_in @user
    get edit_bulletin_url(@bulletin)
    assert_response :success
  end

  test 'unauth user should not get edit' do
    get edit_bulletin_url(@bulletin)
    assert_redirected_to root_path
  end

  test 'should update bulletin' do
    sign_in @user

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

  test 'unauth user should not destroy bulletin' do
    delete bulletin_url(@bulletin)

    assert { Bulletin.find_by(id: @bulletin.id) }
    assert_redirected_to root_path
  end

  test 'signed user should destroy bulletin' do
    sign_in @user
    delete bulletin_url(@bulletin)

    assert_nil Bulletin.find_by(id: @bulletin.id)
    assert_redirected_to bulletins_path
  end
end
