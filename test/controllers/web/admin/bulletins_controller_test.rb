# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @bulletin = bulletins(:under_moderation)
    sign_in @admin
  end

  test 'admin should get the bulletins page' do
    get admin_bulletins_path
    assert_response :success
  end

  test 'admin should destory bulletin' do
    delete admin_bulletin_path @bulletin

    assert_nil Bulletin.find_by(id: @bulletin.id)
    assert_redirected_to admin_bulletins_path
  end

  test 'admin should reject bulletin' do
    patch reject_admin_bulletin_path @bulletin

    @bulletin.reload

    assert { @bulletin.aasm.current_state == Bulletin::STATE_REJECTED }

    assert_redirected_to admin_bulletins_path
  end

  test 'admin should publish bulletin' do
    patch publish_admin_bulletin_path @bulletin

    @bulletin.reload

    assert { @bulletin.aasm.current_state == Bulletin::STATE_PUBLISHED }

    assert_redirected_to admin_bulletins_path
  end

  test 'admin should archive bulletin' do
    patch archive_admin_bulletin_path @bulletin

    @bulletin.reload

    assert { @bulletin.aasm.current_state == Bulletin::STATE_ARCHIVED }

    assert_redirected_to admin_bulletins_path
  end

  test 'search bulletin' do
    get admin_bulletins_path, params: {
      q: @bulletin.title
    }

    assert_response :success
  end
end
