class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    member_rules if user
    admin_rules if user && user.admin?
  end

  def member_rules
    can [:index, :dossiers, :try_new_dossier], :home
    can :update, User, id: user.id

    can :create, Dossier
    can [:read, :update], Dossier, centre_id: user.centre_id
    cannot :destroy, Dossier

    can :manage, :correspondants, centre_id: user.centre_id

    can :read, [Produit, Indication, Dci, Malformation, Pathology, Search]
    can :tree, [Malformation, Pathology]
    can [:create, :update], Search
    cannot :index, Search
  end

  def admin_rules
    can :manage, :all
    cannot :destroy, User, id: user.id
  end
end
