# frozen_string_literal: true

class Web::Admin::HomeController < Web::Admin::ApplicationController
  def index
    authorize Bulletin, policy_class: Admin::BulletinPolicy
    @q = Bulletin.where(state: Bulletin::STATE_UNDER_MODERATION.to_s).order(created_at: :desc).ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
  end
end
