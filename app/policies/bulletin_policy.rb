# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def show?
    return true if record.state == Bulletin::STATE_PUBLISHED

    user&.id == record.id || user&.admin?
  end

  def create?
    user
  end

  def update?
    record.user_id == user&.id || user&.admin?
  end

  def destroy?
    record.user_id == user&.id || user&.admin?
  end
end
