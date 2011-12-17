class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :destroy, :to => :modify

    if user.role? :centre_user
      dossier_and_decorator = [Dossier, DossierDecorator]
      can :dashboard
      can :access, :rails_admin
      can :read, Centre

      can [:read, :update], [user, UserDecorator]
      cannot :destroy, [user, UserDecorator]

      can :create, Dossier
      can :read, dossier_and_decorator
      can :update, dossier_and_decorator, :user_id => user.id
      cannot :destroy, dossier_and_decorator
      can :destroy, dossier_and_decorator, :user_id => user.id

      can :read, [Produit, Malformation]
      can :manage, [Bebe, Exposition]
    end
    if user.role? :centre_admin
      can :update, Centre, :id => user.centre_id
      can :manage, User, :centre_id => user.centre_id
      cannot :destroy, user

      can :manage, dossier_and_decorator, :centre_id => user.centre_id
    end
    if user.role? :admin
      can :manage, :all
      cannot :destroy, user
    end

   # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
