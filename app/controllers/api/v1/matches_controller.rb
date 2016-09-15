class Api::V1::MatchesController < Api::ApiController
  before_action :authenticate_with_token!

  def show
    @matches = []
    # @array_of_users = []
    @in_your_gym = User.where(:gym_id => current_user.gym_id).where("id != ?", current_user.id).where(:gender => current_user.gender)

    @in_your_gym.each do |member|
      intersection = member.hours_in_gym & current_user.hours_in_gym
      if intersection.present?
        @matches.push(member)
      end
    end

  end
end
