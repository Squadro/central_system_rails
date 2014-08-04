class PalettesController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:create]
    
  def create
    @palette = Palette.add_new(palette_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
    
  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @palette  = e.document
    
    Rails.logger.error "Error creating palette: #{e.message}"
    
    respond_to do |format|
      format.html { render :new, errors: @errors }
      format.json { render json: {errors: @errors}, status: 422 }
    end
  end

  def new
  end
  
  def edit
    if(@palette.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_url
      return
    end
  end
  
  def update
    if(@palette.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_url
      return
    end
    
    result = @palette.update_attributes!(palette_create_params)
    redirect_to "/palettes/#{@palette.id}/edit", :notice => 'Data was successfully updated.'
    return

  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @palette  = e.document
    Rails.logger.error "Error updating palette: #{e.message}"
  
    respond_to do |format|
      format.html { render :edit, errors: @errors }
      format.json { render json: {errors: @errors}, status: 422 }
    end     
  end
  
  def destroy
    if(@palette.nil?)
      flash[:error] = "You are trying to destroy an invalid app"
      redirect_to root_path
      return
    end
    
    @palette.delete
  end

  private

  def palette_create_params
    params.require(:palette).permit(:code, :colors => [])
  end
  
end