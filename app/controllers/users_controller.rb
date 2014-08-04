class UsersController < ApplicationController
  
  include Devise::Controllers::Rememberable
  #before_filter :authenticate_user!
  #load_and_authorize_resource :except => [:create, :new]
  
  def new
    @user = User.new
  end
  
  def create
    # authorize! if can? :create, User    # Raise CanCan exception for no authority if current_user 
                                       # cannot create an User
    @user = User.add_new(user_params)
    # if @user.role == "super_admin" || @user.role == "admin"
    #   sign_in(@user)
    #   remember_me(@user)
    # end
    respond_to do |format|
      format.html { redirect_to(root_path, :notice => 'Success. User signed up!  ') }
      format.json { render :json => @user, :status => 200 }
    end
    
  rescue Mongoid::Errors::Validations => e
    @errors = e.document.errors
    @user  = e.document
    
    Rails.logger.error "Error creating user: #{e.message}"
    
    respond_to do |format|
      format.html { render :new, errors: @errors }
      format.json { render json: {errors: @errors}, status: 422 }
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :role, :profile_pic, :email, :password, :password_confirmation)
  end
  
end