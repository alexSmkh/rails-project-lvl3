# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  before_action :set_nav_categories, except: :destroy

  def index
    @categories = Category.order(:name)
    authorize :category, policy_class: Admin::CategoryPolicy
  end

  def new
    @category = Category.new
    authorize @category, policy_class: Admin::CategoryPolicy
  end

  def create
    @category = Category.new(category_params)
    authorize @category, policy_class: Admin::CategoryPolicy

    if @category.save
      redirect_to admin_categories_path, notice: t('.successfully_created')
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
    authorize @category, policy_class: Admin::CategoryPolicy
  end

  def update
    @category = Category.find(params[:id])
    authorize @category, policy_class: Admin::CategoryPolicy

    if @category.update(category_params)
      redirect_to admin_categories_path, notice: t('.successfully_updated')
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    authorize @category, policy_class: Admin::CategoryPolicy
    @category.destroy

    redirect_to admin_categories_path, notice: t('.successfully_destroyed')
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
