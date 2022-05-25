# frozen_string_literal: true

class Web::Admin::ApplicationController < Web::ApplicationController
  before_action :authorize_admin

  private

  def authorize_admin
    raise Pundit::NotAuthorizedError unless current_user.admin?
  end
end
