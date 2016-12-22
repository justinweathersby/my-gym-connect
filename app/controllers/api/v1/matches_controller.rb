class Api::V1::MatchesController < Api::ApiController
  before_action :authenticate_with_token!

  def show
    @matches = []

    if (current_user.workout_time.present? && current_user.gender.present? && current_user.gender_match.present?)
      @in_your_gym = User.where(:gym_id => current_user.gym_id).where("id != ?", current_user.id).where.not(:workout_time => nil)

      if (current_user.gender_match == 'both')
        @gender_match = @in_your_gym.where(:gender_match => 'both')
      else
        @gender_match = @in_your_gym.where(:gender => current_user.gender_match).where(:gender_match => current_user.gender)
      end

      # .where(:gender => current_user.gender)
      if (current_user.workout_time == 'all')
        @matches = @gender_match.to_a
      else
        @matches = @gender_match.where(workout_time: [current_user.workout_time, 'all']).to_a
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
