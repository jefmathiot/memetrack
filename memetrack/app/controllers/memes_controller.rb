class MemesController < ApplicationController
  before_action :set_meme, only: [:show, :edit, :update, :destroy]

  # GET /memes
  # GET /memes.json
  def index
    @memes = search_tags Meme.order(created_at: :desc)
  end

  # GET /memes/1
  # GET /memes/1.json
  def show
  end

  # GET /memes/new
  def new
    @meme = Meme.new
  end

  # GET /memes/1/edit
  def edit
  end

  # POST /memes
  # POST /memes.json
  def create
    @meme = Meme.new(meme_params)

    respond_to do |format|
      if @meme.save
        render_success format, :created,
                       'The image was successfully saved, yay!'
      else
        render_failure format, :new, 'Unable to save the image'
      end
    end
  end

  # PATCH/PUT /memes/1
  # PATCH/PUT /memes/1.json
  def update
    respond_to do |format|
      if @meme.update(meme_params)
        render_success format, :ok, 'The tags were successfully updated, yay!'
      else
        render_failure format, :edit, 'Unable to save the tags'
      end
    end
  end

  # DELETE /memes/1
  # DELETE /memes/1.json
  def destroy
    @meme.destroy
    respond_to do |format|
      format.html do
        redirect_to memes_url,
                    notice: 'The image was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  class MemeParams
    class << self
      def build(params)
        tags = { tags: [] }
        params.require(:meme).tap do |meme|
          meme[:tags] = normalize_tags(params[:meme][:tags])
        end.permit(:picture, tags)
      end

      def normalize_tags(param)
        (param || '').split(',').map(&:strip)
      end
    end
  end

  private

  def render_success(format, status, message)
    format.html do
      redirect_to memes_url, notice: message
    end
    format.json { render :show, status: status, location: @meme }
  end

  def render_failure(format, template, message)
    format.html do
      flash.now[:alert] = message
      render template
    end
    format.json { render json: @meme.errors, status: :unprocessable_entity }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_meme
    @meme = Meme.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def meme_params
    MemeParams.build(params)
  end

  def search_tags(query)
    return query unless params[:q].present?
    query.all_tags(MemeParams.normalize_tags(params[:q]))
  end
end
