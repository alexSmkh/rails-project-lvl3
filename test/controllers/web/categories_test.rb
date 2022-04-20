# frozen_string_literal: true

class Web::CategoriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get categories_path

    assert_response :success
  end

  test 'should get show' do
    category = categories(:one)

    get category_path(category)

    assert_response :success
  end
end
