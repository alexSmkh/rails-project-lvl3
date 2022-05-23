# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  def show
    authorize Bulletin, policy_class: Profile::BulletinPolicy
    @q = Bulletin.where(user_id: current_user.id).ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
    @states = Bulletin.aasm.states.map { |state| [state.human_name, state] }
  end
end
