# frozen_string_literal: true

require 'application_system_test_case'

class CategoriesTest < ApplicationSystemTestCase
  setup do
    @first_category = categories(:one)
    @second_category = categories(:two)
    @user = users(:one)
  end

  test 'visit index page' do
    visit categories_path

    assert page.has_content? I18n.t('categories')

    assert page.has_content? @first_category.name
    assert page.has_content? @second_category.name

    assert page.has_content? "#{I18n.t('bulletins')}: #{@first_category.published_count}"
    assert page.has_content? "#{I18n.t('bulletins')}: #{@second_category.published_count}"

    # Order test
    within('div.x-card-hover', match: :first) do
      assert page.has_content? @second_category.name
    end
  end

  test 'visit show page form index' do
    path = category_path(@first_category)
    visit categories_path

    find("a[href='#{path}']").click

    assert_current_path path
  end

  test 'visit show page' do
    visit category_path(@first_category)

    assert page.has_selector? 'h1', text: @first_category.name

    @first_category.bulletins.each do |bulletin|
      next unless bulletin.published?

      assert page.has_link? bulletin.title, href: bulletin_path(bulletin)
      assert page.has_content? bulletin.description.truncate(100)
      assert page.has_content? posted_by(bulletin)
    end
  end
end
