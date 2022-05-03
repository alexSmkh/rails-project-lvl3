# frozen_string_literal: true

module BulletinsHelper
  def posted_by(bulletin)
    safe_join(
      [
        content_tag(:span, t('posted_by'), class: 'me-1'),
        content_tag(:span, bulletin.user.name, class: 'fst-italic text-secondary fw-bolder me-1'),
        content_tag(:span, "#{time_ago_in_words(bulletin.created_at)} ago")
      ]
    )
  end

  def build_state_badge(bulletin)
    badges = {
      draft: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge x-badge-secondary') },
      under_moderation: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge x-badge-info') },
      published: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge x-badge-success') },
      rejected: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge x-badge-danger') },
      archived: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge x-badge-warning') }
    }

    badges[bulletin.aasm.current_state].call
  end
end
