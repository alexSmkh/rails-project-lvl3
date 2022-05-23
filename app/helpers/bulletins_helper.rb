# frozen_string_literal: true

module BulletinsHelper
  def posted_by(bulletin)
    safe_join(
      [
        content_tag(:span, t('posted_by'), class: 'me-1'),
        content_tag(:span, bulletin.user.name, class: 'fst-italic text-secondary fw-bolder me-1'),
        content_tag(:span, "#{time_ago_in_words(bulletin.created_at)} #{t('ago').downcase}")
      ]
    )
  end

  def build_state_badge(bulletin)
    badges = {
      draft: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge bg-secondary') },
      under_moderation: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge bg-info') },
      published: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge bg-success') },
      rejected: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge bg-danger') },
      archived: -> { content_tag(:span, bulletin.aasm.human_state, class: 'badge bg-warning') }
    }

    badges[bulletin.aasm.current_state].call
  end
end
