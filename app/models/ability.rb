class Ability
  include CanCan::Ability

  def initialize(user)
    #can :manage, :all
    user ||= User.new # guest user. May be we can create 
    
    if user.role == "super_admin"
      can :manage, :all
    elsif user.role == "admin"
      can [:create, :update], [Product, Upload, Palette, Color, ProductCode, User]
      can :read, :all
    elsif user.role == "designer"
      can [:create, :update], [Product, Upload]
      can :create, [Palette, Color, ProductCode]
      can :read, :all
    elsif user.role == "content_writer"  
      can :update, Product
      can :read, :all
    end
  end
end
