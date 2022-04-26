# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    authorize Bulletin, policy_class: Admin::BulletinPolicy
    @bulletins = Bulletin.order(created_at: :desc)
    set_nav_categories
  end

  def moderation
    authorize Bulletin, policy_class: Admin::BulletinPolicy

    @bulletins = Bulletin.where(state: Bulletin::STATE_UNDER_MODERATION.to_s).order(created_at: :desc)
    set_nav_categories
  end

  def archive
    bulletin = Bulletin.find(params[:bulletin_id])
    authorize bulletin, policy_class: Admin::BulletinPolicy

    if bulletin.archive!
      redirect_to admin_moderation_path, notice: t('.success')
    else
      redirect_back fallback_location: admin_bulletins_path, alert: t('.failed')
    end
  end

  def reject
    bulletin = Bulletin.find(params[:bulletin_id])
    authorize bulletin, policy_class: Admin::BulletinPolicy

    if bulletin.reject!
      redirect_to admin_moderation_path, notice: t('.success')
    else
      redirect_back fallback_location: admin_bulletins_path, alert: t('.failed')
    end
  end

  def publish
    bulletin = Bulletin.find(params[:bulletin_id])
    authorize bulletin, policy_class: Admin::BulletinPolicy

    if bulletin.publish!
      redirect_to admin_moderation_path, notice: t('.success')
    else
      redirect_back fallback_location: admin_bulletins_path, alert: t('.failed')
    end
  end
end
