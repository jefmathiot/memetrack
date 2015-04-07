class MemesController < ApplicationController
  before_action :set_meme, only: [:show, :edit, :update, :destroy]

  # GET /memes
  # GET /memes.json
  def index
    @memes = Meme.order(created_at: :desc)
    @memes = @memes.all_tags(normalize_tags(params[:q])) if params[:q].present?
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
        format.html { redirect_to memes_url,
          notice: 'The image was successfully saved, yay!' }
        format.json { render :show, status: :created, location: @meme }
      else
        format.html {
          flash.now[:alert]='Unable to save the image'
          render :new
        }
        format.json { render json: @meme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memes/1
  # PATCH/PUT /memes/1.json
  def update
    respond_to do |format|
      if @meme.update(meme_params)
        format.html { redirect_to memes_url,
          notice: 'The tags were successfully updated, yay!' }
        format.json { render :show, status: :ok, location: @meme }
      else
        format.html {
          flash.now[:alert]='Unable to save the tags'
          render :edit
        }
        format.json { render json: @meme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memes/1
  # DELETE /memes/1.json
  def destroy
    @meme.destroy
    respond_to do |format|
      format.html { redirect_to memes_url,
        notice: 'The image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meme
      @meme = Meme.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meme_params
      params[:meme] && params[:meme].tap{|meme|
        meme[:tags]=normalize_tags(params[:meme][:tags])
      }.permit(:picture, {tags: []})
    end

    def normalize_tags(param)
      (param || '').split(',').map(&:strip)
    end
end
