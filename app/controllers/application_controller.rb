# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def set_nav_categories
    @nav_categories = Category.order(:name)
  end

  private

  def user_not_authorized
    flash[:alert] = t('messages.user_not_authorized')
    redirect_to root_path
  end
end
