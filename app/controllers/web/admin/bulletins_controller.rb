# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    @bulletins = Bulletin.order(created_at: :desc)
    set_nav_categories
  end
end
