# frozen_string_literal: true

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @user = users(:one)
    @category = categories(:one)
    sign_in @admin
  end

  test 'admin should get categories page' do
    get admin_categories_path

    assert_response :success
  end

  test 'admin should get new' do
    get new_admin_category_path

    assert_response :success
  end

  test 'admin should create category' do
    name = Faker::Commerce.department(max: 1)
    post admin_categories_path, params: { category: { name: name } }

    new_category = Category.find_by(name: name)

    assert { new_category }
    assert_redirected_to admin_categories_path
  end

  test 'admin should get edit' do
    get edit_admin_category_path(@category)

    assert_response :success
  end

  test 'admin should update category' do
    name = Faker::Commerce.department(max: 1)

    patch admin_category_path(@category), params: { category: { name: name } }

    @category.reload

    assert { @category.name == name }
    assert_redirected_to admin_categories_path
  end

  test 'admin should delete category' do
    delete admin_category_path(@category)

    assert_nil Category.find_by(id: @category.id)
    assert_redirected_to admin_categories_path
  end
end
