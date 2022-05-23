# frozen_string_literal: true

class Admin::BulletinPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end

  def reject?
    user&.admin?
  end

  def archive?
    user&.admin?
  end

  def publish?
    user&.admin?
  end
end
