# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in @admin
  end

  test 'admin should get index' do
    get admin_categories_path
    assert_response :success
  end
end
