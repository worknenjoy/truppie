class UsersController < ApplicationController
	def follow
    @organizer = Organizer.find(params[:organizer_id])
    current_user.follow @organizer
    OrganizerMailer.new_follower(@organizer, current_user).deliver_now
  end
  
  def unfollow
    @organizer = Organizer.find(params[:organizer_id])
    current_user.unfollow @organizer
  end
end
