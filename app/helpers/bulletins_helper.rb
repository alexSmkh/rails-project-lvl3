# frozen_string_literal: true

module BulletinsHelper
  def posted_by(bulletin)
    user_link = link_to bulletin.user.name, '#', class: 'fst-italic text-secondary fw-bolder x-text-underline-hover'
    time_ago = time_ago_in_words bulletin.created_at
    "#{t('posted_by')} #{user_link} #{time_ago}".html_safe
  end
end
