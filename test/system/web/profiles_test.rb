# frozen_string_literal: true

require 'application_system_test_case'

class ProfilesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @bulletin = bulletins(:one)
    sign_in @user
  end

  test 'visit profile page' do
    visit profile_path

    assert page.has_selector? 'h1', text: I18n.t('profile')

    assert page.has_content? I18n.t('web.profiles.index.title')
    assert page.has_content? I18n.t('web.profiles.index.status')
    assert page.has_content? I18n.t('web.profiles.index.date')
    assert page.has_content? I18n.t('web.profiles.index.actions')

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
end
