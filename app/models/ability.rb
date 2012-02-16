class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :destroy, :to => :modify

    if user.role? :centre_user
      can [:read, :update], user
      cannot :destroy, user

      can :manage, Dossier, :centre_id => user.centre_id
      cannot :destroy, Dossier

      can :manage, Correspondant, :centre_id => user.centre_id
      cannot :destroy, Correspondant

      can :read, [Produit, Malformation, Pathologie, Search]
      can :manage, [Bebe, Exposition, Search]
      cannot :index, [Bebe, Exposition, Search]
      cannot :destroy, Search
    end
    if user.role? :centre_admin
      can :dashboard
      can :access, :rails_admin
      can :destroy, Dossier, :centre_id => user.centre_id
      can :read, Centre
      can :update, Centre, :id => user.centre_id
      can :manage, User, :centre_id => user.centre_id
      cannot :destroy, user
      can :manage, Correspondant, :centre_id => user.centre_id
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
