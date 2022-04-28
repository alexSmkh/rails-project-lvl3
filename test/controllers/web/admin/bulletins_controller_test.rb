# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @bulletin = bulletins(:one)
    @bulletin.moderate!
    sign_in @admin
  end

  test 'admin should get index' do
    get admin_categories_path
    assert_response :success
  end

  test 'admin should get moderation' do
    get admin_moderation_path
    assert_response :success
  end

  test 'admin should reject bulletin' do
    patch admin_bulletin_reject_path @bulletin

    @bulletin.reload

    assert { @bulletin.aasm.current_state == Bulletin::STATE_REJECTED }

    assert_redirected_to admin_bulletins_path
  end

  test 'admin should publish bulletin' do
    patch admin_bulletin_publish_path @bulletin

    @bulletin.reload

    assert { @bulletin.aasm.current_state == Bulletin::STATE_PUBLISHED }

    assert_redirected_to admin_bulletins_path
  end

  test 'admin should archive bulletin' do
    patch admin_bulletin_archive_path(@bulletin)

    @bulletin.reload

    assert { @bulletin.aasm.current_state == Bulletin::STATE_ARCHIVED }

    assert_redirected_to admin_bulletins_path
  end
end
