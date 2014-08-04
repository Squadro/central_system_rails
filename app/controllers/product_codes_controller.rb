class ProductCodesController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:create]
  
  def create
    unauthorized! if cannot? :create, ProductCode
    
    @product_code = ProductCode.add_new(product_code_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
    
  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @product_code  = e.document
    
    Rails.logger.error "Error creating product code: #{e.message}"
    
    respond_to do |format|
      format.html { render :new, errors: @errors }
      format.json { render json: {errors: @errors}, status: 422 }
    end
  end

  def new
  end
  
  def edit
    if(@product_code.nil?)
      flash[:error] = "You have requested an invalid data item to edit"
      redirect_to root_path
      return
    end
  end
  
  def update
    if(@product_code.nil?)
      flash[:error] = "You are trying to update an invalid product code"
      redirect_to root_path
      return
    end
    
    result = @product_code.update_attributes!(product_code_create_params)
    redirect_to "/product_codes/#{@product_code.id}/edit", :notice => 'Data was successfully updated.'
    return

  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @product_code  = e.document
    Rails.logger.error "Error updating product code: #{e.message}"
  
    respond_to do |format|
      format.html { render :edit, errors: @errors }
      format.json { render json: {errors: @errors}, status: 422 }
    end
  end

  def destroy
    if(@product_code.nil?)
      flash[:error] = "You are trying to destroy an invalid color"
      redirect_to root_path
      return
    end
    
    @product_code.delete
  end

  private

  def product_code_create_params
    params.require(:product_code).permit(:name, :description)
  end
  
end