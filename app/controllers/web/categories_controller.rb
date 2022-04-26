# frozen_string_literal: true

class Web::CategoriesController < Web::ApplicationController
  def index
    @categories = Category.all
    set_nav_categories
  end

  def show
    @category =
      Category.find(params[:id])
    @bulletins = Bulletin.includes(:user, { image_attachment: :blob })
                         .where(category_id: params[:id], state: Bulletin::STATE_PUBLISHED)
                         .order(created_at: :desc)
    set_nav_categories
  end
end
