# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    authorize Bulletin, policy_class: Admin::BulletinPolicy
    @q = Bulletin.order(created_at: :desc).ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
    @states = Bulletin.aasm.states.map { |state| [state.human_name, state] }
  end

  def destroy
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin, policy_class: Admin::BulletinPolicy
    @bulletin.destroy

    redirect_back fallback_location: admin_bulletins_path,
                  notice: t('.successfully_destroyed')
  end

  def moderation
    authorize Bulletin, policy_class: Admin::BulletinPolicy

    @q = Bulletin.where(state: Bulletin::STATE_UNDER_MODERATION.to_s).order(created_at: :desc).ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
  end

  def archive
    bulletin = Bulletin.find(params[:id])
    authorize bulletin, policy_class: Admin::BulletinPolicy

    if bulletin.archive!
      redirect_back fallback_location: admin_bulletins_path, notice: t('.success')
    else
      redirect_back fallback_location: admin_bulletins_path, alert: t('.failed')
    end
  end

  def reject
    bulletin = Bulletin.find(params[:id])
    authorize bulletin, policy_class: Admin::BulletinPolicy

    if bulletin.reject!
      redirect_back fallback_location: admin_bulletins_path, notice: t('.success')
    else
      redirect_back fallback_location: admin_bulletins_path, alert: t('.failed')
    end
  end

  def publish
    bulletin = Bulletin.find(params[:id])
    authorize bulletin, policy_class: Admin::BulletinPolicy

    if bulletin.publish!
      redirect_back fallback_location: admin_bulletins_path, notice: t('.success')
    else
      redirect_back fallback_location: admin_bulletins_path, alert: t('.failed')
    end
  end
end
