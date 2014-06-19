class ClientsController < ApplicationController
  
  #TODO: Authenticate the correct user
  
  def create
    @client = Client.add_new(client_create_params)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
    
    #TODO : Add Validation error handling
  end

  def new
    @client = Client.new
  end
  
  private

  def client_create_params
    params.require(:client).permit(:name, :email, :phone_number)
  end
end