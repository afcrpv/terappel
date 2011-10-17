class Ability
  include CanCan::Ability

  def initialize(user)
    guest = User.new
    guest.role = ""
    user ||= guest

    if user.role? :centre_user
      can :read, user
      can :update, user
      cannot :destroy, user

      can :create, Dossier
      can :read, Dossier
      can :update, Dossier, :user_id => user.id
      cannot :destroy, Dossier
    end
    if user.role? :centre_admin
      can :manage, User, :centre_id => user.centre_id
      cannot :destroy, user

      can :manage, Dossier, :centre_id => user.centre_id
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
