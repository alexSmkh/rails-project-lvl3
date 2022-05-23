# frozen_string_literal: true

class Web::Admin::HomeController < Web::Admin::ApplicationController
  before_action :authorize_admin

  def index
    @bulletins = Bulletin.under_moderation.order(created_at: :desc).page(params[:page])
  end
end
