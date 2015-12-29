class MoodboardCommentsController < ApplicationController


  # POST /MoodboardComments
  # POST /MoodboardComments.json
  def create
    @moodboard_comment = MoodboardComment.new(params[:moodboard_comment])

    respond_to do |format|
      if @moodboard_comment.save
        format.html { redirect_to moodboard_path(id: @moodboard_comment.moodboard_item.moodboard.id), notice: 'Moodboard comment was successfully created.' }
        format.json { render json: @moodboard_comment, status: :created, location: @moodboard_comment }
      else
        format.html { redirect_to moodboard_path(id: MoodboardItem.find(params[:moodboard_comment][:moodboard_item_id]).moodboard.id, errors: @moodboard_comment.errors) }
        format.json { render json: @moodboard_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /MoodboardComments/1
  # PUT /MoodboardComments/1.json
  def update
    @moodboard_comment = MoodboardComment.find(params[:id])
    if @moodboard_comment.user_id != current_spree_user.id
      respond_to do |format|
        format.html { redirect_to moodboard_path(id: @moodboard_comment.moodboard_item.moodboard.id), error: 'Not authorised to update comment.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        if @moodboard_comment.update_attributes(params[:moodboard_comment])
          format.html { redirect_to moodboard_path(id: @moodboard_comment.moodboard_item.moodboard.id), notice: 'Moodboard comment was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { redirect_to moodboard_path(id: @moodboard_comment.moodboard_item.moodboard.id), errors: @moodboard_comment.errors }
          format.json { render json: @moodboard_comment.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # DELETE /MoodboardComments/1
  # DELETE /MoodboardComments/1.json
  def destroy
    @moodboard_comment = MoodboardComment.find(params[:id])
    if @moodboard_comment.user_id != current_spree_user.id
      respond_to do |format|
        format.html { redirect_to moodboard_path(id: @moodboard_comment.moodboard_item.moodboard.id), error: 'Not authorised to delete comment.' }
        format.json { head :no_content }
      end
    else
      @moodboard_comment.destroy

      respond_to do |format|
        format.html { redirect_to moodboard_path(id: @moodboard_comment.moodboard_item.moodboard.id) }
        format.json { head :no_content }
      end
    end
  end
end
