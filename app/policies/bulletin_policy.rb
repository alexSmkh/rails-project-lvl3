# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def create?
    user
  end

  def update?
    record.user_id == user&.id
  end

  def destroy?
    record.user_id == user&.id
  end
end
