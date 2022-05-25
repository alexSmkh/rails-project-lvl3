# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def show?
    return true if record.published?

    creator_or_admin?
  end

  def create?
    true
  end

  def update?
    creator_or_admin?
  end

  def destroy?
    creator_or_admin?
  end

  def moderate?
    creator?
  end

  def archive?
    creator?
  end

  private

  def creator?
    record.user_id == user.id
  end

  def creator_or_admin?
    creator? || user.admin?
  end
end
