# frozen_string_literal: true

module BulletinsHelper
  def posted_by(bulletin)
    user_link = link_to bulletin.user.name, '#', class: 'fst-italic text-secondary fw-bolder x-text-underline-hover'
    time_ago = time_ago_in_words bulletin.created_at
    "#{t('posted_by')} #{user_link} #{time_ago}".html_safe
  end

  def build_state_badge(state)
    badges = {
      draft: -> { content_tag(:span, t("web.bulletins.states.#{state}"), class: 'badge x-badge-secondary') },
      under_moderation: -> { content_tag(:span, t("web.bulletins.states.#{state}"), class: 'badge x-badge-info') },
      published: -> { content_tag(:span, t("web.bulletins.states.#{state}"), class: 'badge x-badge-success') },
      rejected: -> { content_tag(:span, t("web.bulletins.states.#{state}"), class: 'badge x-badge-danger') },
      archived: -> { content_tag(:span, t("web.bulletins.states.#{state}"), class: 'badge x-badge-warning') }
    }

    badges[state].call
  end
end
