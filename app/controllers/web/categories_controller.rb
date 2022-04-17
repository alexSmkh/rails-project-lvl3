# frozen_string_literal: true

class Web::CategoriesController < Web::ApplicationController
  def index
    @categories = Category.all
    set_nav_categories
  end

  def show
    @category =
      Category.includes(bulletins: [:user, { image_attachment: :blob }]).find(params[:id])
    set_nav_categories
  end
end
