# frozen_string_literal: true

class Admin::BulletinPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def moderation?
    user&.admin?
  end

  def reject?
    user&.admin?
  end

  def archive?
    user&.id == record.id || user&.admin?
  end

  def publish?
    user&.admin?
  end
end
