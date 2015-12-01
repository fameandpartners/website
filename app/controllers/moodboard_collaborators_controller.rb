class MoodboardCollaboratorsController < ApplicationController
  before_filter :authenticate_spree_user!

  def create
    name  = params[:moodboard_collaborator][:name]
    email = params[:moodboard_collaborator][:email]

    existing = moodboard.collaborators.where(email: email).exists?

    new_collaborator = moodboard.collaborators.build(name: name, email: email)

    if existing
      message = { notice: "#{new_collaborator.email} is already on this moodboard!" }
    elsif new_collaborator.valid?
      new_collaborator.set_user
      new_collaborator.save
      message = { notice: "#{new_collaborator.name} added!" }
    else
      message = { error: new_collaborator.errors.full_messages }
    end

    redirect_to moodboard_path(moodboard), flash: message
  end

  def index
    render json: moodboard.collaborators
  end

  private def moodboard
    candidate_id = params[:moodboard_id].to_i
    spree_current_user.moodboards.find(candidate_id)
  end
end
