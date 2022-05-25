# frozen_string_literal: true

require 'application_system_test_case'

class AdminCategoriesTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin)
    @first_category = categories(:one)
    @second_category = categories(:two)
    sign_in @admin
  end

  test 'visit category index' do
    visit admin_categories_path

    assert page.has_link? I18n.t('bulletins'), href: admin_bulletins_path
    assert page.has_link? I18n.t('categories'), href: admin_categories_path
    assert page.has_link? I18n.t('bulletin_moderation'), href: admin_root_path

    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.categories.index.id')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.categories.index.name')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.categories.index.actions')

    assert page.has_link? I18n.t('web.admin.categories.index.create'),
                          href: new_admin_category_path

    within(find('td', text: @first_category.name).find(:xpath, '../..')) do
      assert page.has_content? @first_category.id
      assert page.has_content? @first_category.name
      assert find_link('', href: edit_admin_category_path(@first_category))
      assert find_link('', href: admin_category_path(@first_category))

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
      assert page.has_selector? 'i.fa-solid.fa-trash'
    end

    within(find('td', text: @second_category.name).find(:xpath, '../..')) do
      assert page.has_content? @second_category.id
      assert page.has_content? @second_category.name
      assert find_link('', href: edit_admin_category_path(@second_category))
      assert find_link('', href: admin_category_path(@second_category))

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
      assert page.has_selector? 'i.fa-solid.fa-trash'
    end
  end

  test 'visit category new page from admin category index' do
    visit admin_categories_path

    click_on I18n.t('web.admin.categories.index.create')

    assert_current_path new_admin_category_path
  end

  test 'visit category new page' do
    name = Faker::Commerce.department(max: 1)

    visit new_admin_category_path

    assert page.has_selector? 'h1',
                              text: I18n.t('web.admin.categories.new.create')
    fill_in I18n.t('simple_form.labels.category.new.name'), with: name
    click_on I18n.t('helpers.submit.category.create')

    assert_current_path admin_categories_path
    assert page.has_content? name
  end
end
