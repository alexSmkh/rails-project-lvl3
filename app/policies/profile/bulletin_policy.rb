# frozen_string_literal: true

class Profile::BulletinPolicy < ApplicationPolicy
  def index?
    user
  end
end
