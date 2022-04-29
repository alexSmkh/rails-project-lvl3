# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  def index
    @bulletins = Bulletin.where(user_id: current_user.id)
    authorize @bulletins, policy_class: Profile::BulletinPolicy
    set_nav_categories
  end
end
