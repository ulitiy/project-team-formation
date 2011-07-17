class Ability
  include CanCan::Ability

  def initialize(account)
    can :manage, :all
  end
end

