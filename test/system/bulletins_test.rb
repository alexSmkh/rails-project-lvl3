# frozen_string_literal: true

require 'application_system_test_case'

class BulletinsTest < ApplicationSystemTestCase
  include ActionView::Helpers::DateHelper

  setup do
    @first_bulletin = bulletins(:one)
    @second_bulletin = bulletins(:one)
    @user = users(:one)
  end

  test 'visit the root page' do
    visit bulletins_url

    assert page.has_link? '', href: root_path
    assert page.has_selector? 'i.fa-solid.fa-house'
    assert page.has_link? I18n.t('sign_in'), href: new_session_path

    assert page.has_selector? 'h1', text: I18n.t('bulletins')

    assert page.has_link? @first_bulletin.title, href: bulletin_path(@first_bulletin)
    assert page.has_link? @second_bulletin.title, href: bulletin_path(@second_bulletin)

    assert page.has_content? @first_bulletin.description.truncate(100)
    assert page.has_content? @second_bulletin.description.truncate(100)

    assert page.has_selector? 'img'

    assert page.has_selector? 'p', text: "#{I18n.t('posted_by')} #{@first_bulletin.user.name} #{time_ago_in_words @first_bulletin.created_at}".html_safe
    assert page.has_selector? 'p', text: "#{I18n.t('posted_by')} #{@second_bulletin.user.name} #{time_ago_in_words @second_bulletin.created_at}".html_safe

    assert page.has_link? '', href: 'https://github.com/alexSmkh/rails-project-lvl3'
  end

  test 'creating a Bulletin' do
    sign_in @user
  end
end
