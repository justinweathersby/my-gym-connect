class GymsController < InheritedResources::Base

  private

    def gym_params
      params.require(:gym).permit(:name)
    end
end

