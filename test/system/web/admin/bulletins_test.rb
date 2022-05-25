# frozen_string_literal: true

require 'application_system_test_case'
# rubocop:disable Metrics/ClassLength
class AdminBulletinsTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin)
    @draft_bulletin = bulletins(:draft)
    @under_moderation_bulletin = bulletins(:under_moderation)
    @published_bulletin = bulletins(:published)
    @rejected_bulletin = bulletins(:rejected)
    @archived_bulletin = bulletins(:archived)
    sign_in @admin
  end

  test 'visit the admin bulletins page' do
    visit admin_bulletins_path

    assert page.has_link? I18n.t('bulletins'), href: admin_bulletins_path
    assert page.has_link? I18n.t('categories'), href: admin_categories_path
    assert page.has_link? I18n.t('bulletin_moderation'), href: admin_root_path

    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.title')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.status')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.date')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.actions')

    within(find_link(@draft_bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? @draft_bulletin.created_at.strftime('%H:%M %d/%m/%Y')
      assert page.has_content? @draft_bulletin.aasm.human_state
      assert find_link('', href: edit_bulletin_path(@draft_bulletin))
      assert find_link('', href: bulletin_path(@draft_bulletin))
      assert find_link('', href: archive_admin_bulletin_path(@draft_bulletin))

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
      assert page.has_selector? 'i.fa-solid.fa-trash'
      assert page.has_selector? 'i.fa-solid.fa-box-archive'
    end

    within(find_link(@under_moderation_bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? @under_moderation_bulletin.created_at.strftime('%H:%M %d/%m/%Y')
      assert page.has_content? @under_moderation_bulletin.aasm.human_state
      assert find_link('', href: edit_bulletin_path(@under_moderation_bulletin))
      assert find_link('', href: bulletin_path(@under_moderation_bulletin))
      assert find_link('', href: archive_admin_bulletin_path(@under_moderation_bulletin))

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
      assert page.has_selector? 'i.fa-solid.fa-trash'
      assert page.has_selector? 'i.fa-solid.fa-box-archive'
    end

    within(find_link(@published_bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? @published_bulletin.created_at.strftime('%H:%M %d/%m/%Y')
      assert page.has_content? @published_bulletin.aasm.human_state
      assert find_link('', href: edit_bulletin_path(@published_bulletin))
      assert find_link('', href: bulletin_path(@published_bulletin))
      assert find_link('', href: archive_admin_bulletin_path(@published_bulletin))

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
      assert page.has_selector? 'i.fa-solid.fa-trash'
      assert page.has_selector? 'i.fa-solid.fa-box-archive'
    end

    within(find_link(@rejected_bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? @rejected_bulletin.created_at.strftime('%H:%M %d/%m/%Y')
      assert page.has_content? @rejected_bulletin.aasm.human_state
      assert find_link('', href: edit_bulletin_path(@rejected_bulletin))
      assert find_link('', href: bulletin_path(@rejected_bulletin))
      assert find_link('', href: archive_admin_bulletin_path(@rejected_bulletin))

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
      assert page.has_selector? 'i.fa-solid.fa-trash'
      assert page.has_selector? 'i.fa-solid.fa-box-archive'
    end

    within(find_link(@archived_bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? @archived_bulletin.created_at.strftime('%H:%M %d/%m/%Y')
      assert page.has_content? @archived_bulletin.aasm.human_state
      assert find_link('', href: edit_bulletin_path(@archived_bulletin))
      assert find_link('', href: bulletin_path(@archived_bulletin))
      assert page.has_no_selector? "a[href='#{archive_admin_bulletin_path(@archived_bulletin)}'"

      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
      assert page.has_selector? 'i.fa-solid.fa-trash'
      assert page.has_no_selector? 'i.fa-solid.fa-box-archive'
    end
  end

  test 'visit moderation page' do
    visit admin_root_path

    assert page.has_link? I18n.t('bulletins'), href: admin_bulletins_path
    assert page.has_link? I18n.t('categories'), href: admin_categories_path
    assert page.has_link? I18n.t('bulletin_moderation'), href: admin_root_path

    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.title')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.status')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.date')
    assert page.has_selector? 'th',
                              text: I18n.t('web.admin.bulletins.index.actions')

    within(find_link(@under_moderation_bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? @under_moderation_bulletin.created_at.strftime('%H:%M %d/%m/%Y')
      assert page.has_content? @under_moderation_bulletin.aasm.human_state
      assert find_link('', href: publish_admin_bulletin_path(@under_moderation_bulletin))
      assert find_link('', href: reject_admin_bulletin_path(@under_moderation_bulletin))
      assert find_link('', href: archive_admin_bulletin_path(@under_moderation_bulletin))

      assert page.has_selector? 'i.fa-solid.fa-check'
      assert page.has_selector? 'i.fa-solid.fa-ban'
      assert page.has_selector? 'i.fa-solid.fa-box-archive'
    end

    assert page.has_no_selector? "a[href='#{bulletin_path(@draft_bulletin)}'", text: @draft_bulletin.title
    assert page.has_no_selector? "a[href='#{bulletin_path(@published_bulletin)}'", text: @published_bulletin.title
    assert page.has_no_selector? "a[href='#{bulletin_path(@rejected_bulletin)}'", text: @rejected_bulletin.title
    assert page.has_no_selector? "a[href='#{bulletin_path(@archived_bulletin)}'", text: @archived_bulletin.title
  end

  test 'search bulletin' do
    visit admin_bulletins_path

    fill_in('q_title_cont', with: @under_moderation_bulletin.title)
    click_button I18n.t('search')

    assert page.has_link? @under_moderation_bulletin.title, href: bulletin_path(@under_moderation_bulletin)
    Bulletin.all.each do |bulletin|
      next if bulletin.id == @under_moderation_bulletin.id

      assert page.has_no_link? bulletin.title, href: bulletin_path(bulletin)
    end

    click_link I18n.t('reset')
    assert_current_path admin_bulletins_path

    select(@under_moderation_bulletin.aasm.human_state, from: 'q_state_eq')
    click_button I18n.t('search')

    assert page.has_link? @under_moderation_bulletin.title, href: bulletin_path(@under_moderation_bulletin)
    Bulletin.where.not(state: @under_moderation_bulletin.state).each do |bulletin|
      assert page.has_no_link? bulletin.title, href: bulletin_path(bulletin)
    end
  end
end
# rubocop:enable Metrics/ClassLength
