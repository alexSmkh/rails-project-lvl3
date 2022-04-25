# frozen_string_literal: true

class BulletinsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test 'visit the home page as unauth user' do
    visit root_path

    assert page.has_link? '', href: root_path
    assert page.has_selector? 'i.fa-solid.fa-house'
    assert page.has_link? I18n.t('sign_in'), href: new_session_path
  end

  test 'visit the home page as signed user' do
    sign_in @user

    visit root_path

    assert page.has_link? '', href: root_path
    assert page.has_selector? 'i.fa-solid.fa-house'
    assert page.has_link? I18n.t('sign_out'), href: session_path
    assert page.has_link? I18n.t('create_bulletin'), href: new_bulletin_path
  end

  test 'visit the signin page from the home page' do
    visit root_path
    click_on I18n.t('sign_in')
    assert_current_path new_session_path
  end

  test 'visit the new bulletin page' do
    sign_in @user

    visit root_path

    click_link I18n.t('create_bulletin')
    assert_current_path new_bulletin_path
  end

  test 'should show the dialog for sign out' do
    sign_in @user

    visit root_path

    click_link I18n.t('sign_out')

    dismiss_confirm

    assert_current_path root_path
  end
end
