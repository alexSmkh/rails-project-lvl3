# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :set_nav_categories, only: %i[index show new edit]

  def index
    @bulletins = Bulletin.includes(:user, { image_attachment: :blob }).order(created_at: :desc)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
    @bulletin = Bulletin.new
    authorize @bulletin
  end

  def create
    @bulletin = Bulletin.new(bulletin_params)
    @bulletin.user = current_user
    authorize @bulletin

    if @bulletin.save
      redirect_to bulletin_path(@bulletin), notice: t('.successfully_created')
    else
      render :new
    end
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
  end

  def update
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin

    if @bulletin.update(bulletin_params)
      redirect_to bulletin_path(@bulletin), notice: t('.successfully_updated')
    else
      render :edit
    end
  end

  def destroy
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
    @bulletin.destroy

    redirect_to bulletins_path, notice: t('.successfully_destroyed')
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end
end
