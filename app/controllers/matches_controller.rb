class MatchesController < ApplicationController
  before_action :authenticate_user!

  def show
    @matches = []
    # @array_of_users = []
    @in_your_gym = User.where("id != ?", current_user.id).where(:gym_id => current_user.gym_id)

    @in_your_gym.each do |member|
      # @array_of_users.push(member)
      intersection = member.hours_in_gym & current_user.hours_in_gym
      if intersection.present?
        @matches.push(member)
      end
    end

  end
end
