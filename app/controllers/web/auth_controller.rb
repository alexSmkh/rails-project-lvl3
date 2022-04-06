# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    auth_user_info = auth_hash[:info]

    user = User.find_or_initialize_by(email: auth_user_info[:email].downcase)

    unless user.name
      user.name = auth_user_info[:name] || auth_user_info[:nickname] || auth_user_info[:email].split('@').first
    end

    if user.save
      sign_in user
      redirect_to root_path, notice: t('messages.successfully_logged_in')
    else
      redirect_to new_session_path, notice: t('messages.unsuccessfully_logged_in')
    end
  end

  def destroy
    sign_out

    redirect_to root_path, notice: t('messages.successfully_logged_out')
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
