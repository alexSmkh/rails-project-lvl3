# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  def show
    authorize :profile
    @q = current_user.bulletins.ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
    @states = Bulletin.aasm.states.map { |state| [state.human_name, state] }
  end
end
