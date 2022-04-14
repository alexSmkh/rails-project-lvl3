# frozen_string_literal: true

class Web::SessionsController < Web::ApplicationController
  def new
    return unless current_user

    redirect_to root_path, notice: t('messages.already_signed_in')
  end

  def destroy
    sign_out

    redirect_to root_path, notice: t('messages.successfully_logged_out')
  end
end
