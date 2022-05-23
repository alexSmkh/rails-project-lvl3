# frozen_string_literal: true

require 'application_system_test_case'

# rubocop:disable Metrics/ClassLength
class BulletinsTest < ApplicationSystemTestCase
  include ActionView::Helpers::DateHelper

  setup do
    @bulletin = bulletins(:published)
    @second_bulletin = bulletins(:draft)
    @user = users(:one)
  end

  test 'visit bulletin index' do
    visit root_path

    assert page.has_selector? 'h1', text: I18n.t('bulletins')

    assert page.has_link? @bulletin.title, href: bulletin_path(@bulletin)

    assert page.has_content? @bulletin.description.truncate(100)

    assert page.has_selector? 'img'

    assert page.has_selector? 'span', text: I18n.t('posted_by')
    assert page.has_selector? 'span.fst-italic.text-secondary.fw-bolder',
                              text: @bulletin.user.name
    assert page.has_selector? 'span',
                              text:
                                "#{time_ago_in_words(@bulletin.created_at)} #{I18n.t('ago').downcase}"
  end

  test 'creating a bulletin' do
    sign_in @user
    category = categories(:one)

    visit new_bulletin_path

    title = Faker::Commerce.product_name.capitalize
    description = Faker::Lorem.paragraph(sentence_count: 5)

    fill_in I18n.t('simple_form.labels.bulletin.new.title'), with: title
    fill_in I18n.t('simple_form.labels.bulletin.new.description'),
            with: description
    select category.name,
           from: I18n.t('simple_form.labels.bulletin.new.category')
    attach_file I18n.t('simple_form.labels.bulletin.new.image'),
                Rails.root.join('test/fixtures/files/two.png')
    click_on I18n.t('helpers.submit.bulletin.create')

    new_bulletin = Bulletin.last

    assert_current_path bulletin_path(new_bulletin)

    assert page.has_content? I18n.t('web.bulletins.create.success')
    assert page.has_content? title
    assert page.has_content? description
    assert page.has_selector? 'img'
    assert page.has_content? category.name
    assert page.has_content? @user.name
  end

  test 'updating bulletin' do
    sign_in @user
    category = categories(:two)

    visit edit_bulletin_path(@bulletin)

    updated_title = Faker::Commerce.product_name.capitalize
    updated_description = Faker::Lorem.paragraph(sentence_count: 5)

    fill_in I18n.t('simple_form.labels.bulletin.new.title'), with: updated_title
    fill_in I18n.t('simple_form.labels.bulletin.new.description'),
            with: updated_description
    select category.name,
           from: I18n.t('simple_form.labels.bulletin.new.category')
    attach_file I18n.t('simple_form.labels.bulletin.new.image'),
                Rails.root.join('test/fixtures/files/two.png')
    click_on I18n.t('helpers.submit.bulletin.update')

    assert_current_path bulletin_path(@bulletin)

    assert page.has_content? I18n.t('web.bulletins.update.successfully_updated')
    assert page.has_content? updated_title
    assert page.has_content? updated_description
    assert page.has_content? category.name
    assert page.has_selector? 'img'
    assert page.has_content? @user.name
  end

  test 'visit the show bulletin page' do
    sign_in @user

    visit bulletin_path(@bulletin)

    assert page.has_content? @bulletin.title.capitalize
    assert page.has_content? @bulletin.description
    assert page.has_content? @bulletin.user.name
    assert page.has_content? @bulletin.category.name
    assert page.has_selector? 'img'

    within("a[href='#{edit_bulletin_path(@bulletin)}']") do
      assert page.has_selector? 'i.fa-solid.fa-pen-to-square'
    end

    within("a[href='#{bulletin_path(@bulletin)}']") do
      assert page.has_selector? 'i.fa-solid.fa-trash'
    end
  end

  test 'visit the edit bulletin page from the show page' do
    sign_in @user

    visit bulletin_path(@bulletin)

    click_link '', href: edit_bulletin_path(@bulletin)
    assert_current_path edit_bulletin_path(@bulletin)
  end

  test 'should show the dialog for destroying the bulletin' do
    sign_in @user

    visit bulletin_path(@bulletin)

    click_link '', href: bulletin_path(@bulletin)
    dismiss_confirm
  end

  test 'search bulletin' do
    visit bulletins_path

    fill_in('q_title_cont', with: @bulletin.title)
    click_button I18n.t('search')

    assert page.has_link? @bulletin.title, href: bulletin_path(@bulletin)
    Bulletin.published.each do |bulletin|
      next if bulletin.id == @bulletin.id

      assert page.has_no_link? bulletin.title, href: bulletin_path(bulletin)
    end

    click_link I18n.t('reset')
    assert_current_path root_path

    select(@bulletin.category.name, from: 'q_category_id_eq')
    click_button I18n.t('search')

    assert page.has_link? @bulletin.title, href: bulletin_path(@bulletin)
    Bulletin.published.where.not(category: @bulletin.category.name).each do |bulletin|
      assert page.has_no_link? bulletin.title, href: bulletin_path(bulletin)
    end
  end
end
# rubocop:enable Metrics/ClassLength
