# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :set_nav_categories, only: %i[index show new edit]

  def index
    @bulletins = Bulletin.includes(:user, { image_attachment: :blob })
                         .published
                         .order(created_at: :desc)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
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

    redirect_back fallback_location: root_path, notice: t('.successfully_destroyed')
  end

  def archive
    bulletin = Bulletin.find(params[:bulletin_id])
    authorize bulletin

    if bulletin.archive!
      redirect_back fallback_location: bulletins_path, notice: t('.success')
    else
      redirect_back fallback_location: bulletins_path, alert: t('.failed')
    end
  end

  def moderate
    bulletin = Bulletin.find(params[:bulletin_id])
    authorize bulletin

    if bulletin.moderate!
      redirect_back fallback_location: bulletins_path, notice: t('.success')
    else
      redirect_back fallback_location: bulletins_path, alert: t('.failed')
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end
end
