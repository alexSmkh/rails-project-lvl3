# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  def index
    @bulletins = Bulletin.order(created_at: :desc)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
    @bulletin = Bulletin.new
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
  end

  def create
    @bulletin = Bulletin.new(bulletin_params)
    @bulletin.user = current_user

    respond_to do |format|
      if @bulletin.save
        format.html do
          redirect_to bulletin_url(@bulletin),
                      notice: 'Bulletin was successfully created.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @bulletin = Bulletin.find(params[:id])

    respond_to do |format|
      if @bulletin.update(bulletin_params)
        format.html do
          redirect_to bulletin_url(@bulletin),
                      notice: 'Bulletin was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @bulletin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @bulletin.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @bulletin.destroy

    respond_to do |format|
      format.html do
        redirect_to bulletins_url,
                    notice: 'Bulletin was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:name, :description, :category_id, :image)
  end
end
