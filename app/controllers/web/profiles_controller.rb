# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  def index
    @q = Bulletin.where(user_id: current_user.id).ransack(params[:q])
    authorize @bulletins, policy_class: Profile::BulletinPolicy
    @bulletins = @q.result
    @states = Bulletin.aasm.states.map { |state| [state.human_name, state] }
    set_nav_categories
  end
end
