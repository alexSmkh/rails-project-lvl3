# frozen_string_literal: true

require 'application_system_test_case'

class ProfilesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @bulletin = bulletins(:draft)
    sign_in @user
  end

  test 'visit profile page' do
    visit profile_path

    assert page.has_selector? 'h1', text: I18n.t('profile')

    assert page.has_content? I18n.t('web.profiles.show.title')
    assert page.has_content? I18n.t('web.profiles.show.status')
    assert page.has_content? I18n.t('web.profiles.show.date')
    assert page.has_content? I18n.t('web.profiles.show.actions')

    within(find_link(@bulletin.title).find(:xpath, '../..')) do
      assert page.has_content? time_ago_in_words(@bulletin.created_at)
      assert page.has_content? @bulletin.aasm.human_state
      assert find_link('', href: bulletin_path(@bulletin))
      assert find_link('', href: moderate_bulletin_path(@bulletin))
      assert find_link('', href: edit_bulletin_path(@bulletin))
      assert find_link('', href: archive_bulletin_path(@bulletin))

      assert page.has_selector? 'i.fa-solid.fa-dragon'
      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
      assert page.has_selector? 'i.fa-solid.fa-trash'
      assert page.has_selector? 'i.fa-solid.fa-box-archive'
    end
  end

  test 'search bulletin' do
    visit profile_path

    fill_in('q_title_cont', with: @bulletin.title)
    click_button I18n.t('search')

    assert page.has_link? @bulletin.title, href: bulletin_path(@bulletin)
    @user.bulletins.each do |bulletin|
      next if bulletin.id == @bulletin.id

      assert page.has_no_link? bulletin.title, href: bulletin_path(bulletin)
    end

    click_link I18n.t('reset')
    assert_current_path profile_path

    select(@bulletin.aasm.human_state, from: 'q_state_eq')
    click_button I18n.t('search')

    assert page.has_link? @bulletin.title, href: bulletin_path(@bulletin)
    @user.bulletins.where.not(state: @bulletin.state).each do |bulletin|
      assert page.has_no_link? bulletin.title, href: bulletin_path(bulletin)
    end
  end
end
