# frozen_string_literal: true

class Web::Admin::ApplicationController < Web::ApplicationController
  def authorize_admin
    raise Pundit::NotAuthorizedError unless current_user.admin?
  end
end
