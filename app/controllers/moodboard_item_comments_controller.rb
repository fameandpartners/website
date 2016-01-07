class MoodboardItemCommentsController < ApplicationController


  # POST /MoodboardComments
  # POST /MoodboardComments.json
  def create
    moodboard_item_comment = MoodboardItemComment.new(params[:moodboard_item_comment])

    respond_to do |format|
      if moodboard_item_comment.save
        format.html { redirect_to moodboard_path(id: moodboard_item_comment.moodboard_item.moodboard.id), notice: 'Moodboard comment was successfully created.' }
        format.json { render json: moodboard_item_comment.attributes.merge({first_name: moodboard_item_comment.first_name }), status: :created, location: moodboard_item_comment }
      else
        format.html { redirect_to moodboard_path(id: MoodboardItem.find(params[:moodboard_item_comment][:moodboard_item_id]).moodboard.id, errors: moodboard_item_comment.errors) }
        format.json { render json: moodboard_item_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /MoodboardComments/1
  # PUT /MoodboardComments/1.json
  def update
    moodboard_item_comment = MoodboardItemComment.find(params[:id])
    if moodboard_item_comment.user_id != current_spree_user.id
      respond_to do |format|
        format.html { redirect_to moodboard_path(id: moodboard_item_comment.moodboard_item.moodboard.id), error: 'Not authorised to update comment.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        if moodboard_item_comment.update_attributes(params[:moodboard_item_comment])
          format.html { redirect_to moodboard_path(id: moodboard_item_comment.moodboard_item.moodboard.id), notice: 'Moodboard comment was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { redirect_to moodboard_path(id: moodboard_item_comment.moodboard_item.moodboard.id), errors: moodboard_item_comment.errors }
          format.json { render json: moodboard_item_comment.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # DELETE /MoodboardComments/1
  # DELETE /MoodboardComments/1.json
  def destroy
    moodboard_item_comment = MoodboardItemComment.find(params[:id])
    if moodboard_item_comment.user_id != current_spree_user.id
      respond_to do |format|
        format.html { redirect_to moodboard_path(id: moodboard_item_comment.moodboard_item.moodboard.id), error: 'Not authorised to delete comment.' }
        format.json { head :no_content }
      end
    else
      moodboard_item_comment.destroy

      respond_to do |format|
        format.html { redirect_to moodboard_path(id: moodboard_item_comment.moodboard_item.moodboard.id) }
        format.json { head :no_content }
      end
    end
  end
end
