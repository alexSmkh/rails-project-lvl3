# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    admin = users(:admin)
    sign_in admin
  end

  test 'admin should get moderation page' do
    get admin_root_path
    assert_response :success
  end
end
