# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :auth_user!, only: %i[new create edit update destroy]

  def index
    @q = Bulletin.published.order(created_at: :desc).ransack(params[:q])
    @categories = Category.order(name: :asc)
    @bulletins = @q.result.includes(:user, { image_attachment: :blob }).page(params[:page]).per(8)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
  end

  def new
    authorize :bulletin
    @bulletin = Bulletin.new
  end

  def create
    authorize :bulletin
    @bulletin = current_user.bulletins.build(bulletin_params)

    if @bulletin.save
      redirect_to bulletin_path(@bulletin), notice: t('.success')
    else
      render :new, alert: t('.failed')
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

    redirect_to root_path, notice: t('.successfully_destroyed')
  end

  def archive
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    if bulletin.archive!
      redirect_back fallback_location: profile_path, notice: t('.success')
    else
      redirect_back fallback_location: profile_path, alert: t('.failed')
    end
  end

  def moderate
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    if bulletin.moderate!
      redirect_back fallback_location: profile_path, notice: t('.success')
    else
      redirect_back fallback_location: profile_path, alert: t('.failed')
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end
end
