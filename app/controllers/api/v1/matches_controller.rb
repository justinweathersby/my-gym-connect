class Api::V1::MatchesController < Api::ApiController
  before_action :authenticate_with_token!

  def show
    @matches = []
    # @array_of_users = []
    if (current_user.workout_time.present? && current_user.gender.present?)
      @in_your_gym = User.where(:gym_id => current_user.gym_id).where("id != ?", current_user.id).where.not(:workout_time => nil)

      # .where(:gender => current_user.gender)
      if (current_user.workout_time == 'all')
        @matches = @in_your_gym.to_a
      else
        @matches = @in_your_gym.where(workout_time: [current_user.workout_time, 'all']).to_a
      end



      # @in_your_gym.each do |member|
      #   intersection = member.hours_in_gym & current_user.hours_in_gym
      #   if intersection.present?
      #     @matches.push(member)
      #   end
      # end
    end
  end
end
