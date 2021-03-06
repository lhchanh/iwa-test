# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, User, id: user.id

    if user.admin?
      can :manage, :all
    end
  end
end
