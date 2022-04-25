# frozen_string_literal: true

require 'application_system_test_case'

class Admin::BulletinsTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin)
    @first_bulletin = bulletins(:one)
    @second_bulletin = bulletins(:two)
    sign_in @admin
  end

  test 'visit the admin bulletins page' do
    visit admin_bulletins_path

    assert page.has_link? I18n.t('bulletins'), href: '#'
    assert page.has_link? I18n.t('categories'), href: admin_categories_path
    assert page.has_link? I18n.t('bulletin_moderation'), href: '#'

    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.title')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.status')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.date')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.actions')

    within(find_link(@first_bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? time_ago_in_words(@first_bulletin.created_at)
      assert page.has_content? 'Published'
      assert find_link('', href: edit_bulletin_path(@first_bulletin))
      assert find_link('', href: bulletin_path(@first_bulletin))

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square.text-secondary'
      assert page.has_selector? 'i.fa-solid.fa-trash.text-secondary'
    end

    within(find_link(@second_bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? time_ago_in_words(@second_bulletin.created_at)
      assert page.has_content? 'Published'
      assert find_link('', href: edit_bulletin_path(@second_bulletin))
      assert find_link('', href: bulletin_path(@second_bulletin))

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square.text-secondary'
      assert page.has_selector? 'i.fa-solid.fa-trash.text-secondary'
    end
  end
end
