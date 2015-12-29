require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe MoodboardCommentsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # MoodboardComment. As you add validations to MoodboardComment, be sure to
  # adjust the attributes here as well.

  let(:current_user) { create(:spree_user) }
  let(:current_user) { create(:spree_user) }
  let(:moodboard_item) { create(:moodboard_item) }

  let(:valid_attributes) { {moodboard_item_id: moodboard_item.id,
                            user_id:           current_user.id,
                            comment:           'First test comment'} }


  let(:invalid_attributes) { {moodboard_item_id: moodboard_item.id,
                              user_id:           current_user.id,
                              comment:           nil} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MoodboardCommentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:each) { allow(controller).to receive_messages(current_spree_user: current_user) }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new MoodboardComment" do
        expect {
          post :create, {:moodboard_comment => valid_attributes}
        }.to change(MoodboardComment, :count).by(1)
      end

      it "assigns a newly created moodboard_comment as @moodboard_comment" do
        post :create, {:moodboard_comment => valid_attributes}
        expect(assigns(:moodboard_comment)).to be_a(MoodboardComment)
        expect(assigns(:moodboard_comment)).to be_persisted
      end

      it "redirects to the parent moodboard" do
        post :create, {:moodboard_comment => valid_attributes}
        expect(response).to redirect_to(Moodboard.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved moodboard_comment as @moodboard_comment" do
        post :create, {:moodboard_comment => invalid_attributes}
        expect(assigns(:moodboard_comment)).to be_a_new(MoodboardComment)
      end

      it "re-renders the 'moodboard' template" do
        post :create, {:moodboard_comment => invalid_attributes}
        expect(response.location).to match(/moodboard/)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { {comment: 'Update comment'} }

      it "updates the requested moodboard_comment" do

        moodboard_comment = MoodboardComment.create! valid_attributes
        put :update, {:id => moodboard_comment.to_param, :moodboard_comment => new_attributes}
        moodboard_comment.reload
        expect(moodboard_comment.comment).to eq 'Update comment'
      end

      it "assigns the requested moodboard_comment as @moodboard_comment" do
        moodboard_comment = MoodboardComment.create! valid_attributes
        put :update, {:id => moodboard_comment.to_param, :moodboard_comment => valid_attributes}
        expect(assigns(:moodboard_comment)).to eq(moodboard_comment)
      end

      it "redirects to the moodboard_comment" do
        moodboard_comment = MoodboardComment.create! valid_attributes
        put :update, {:id => moodboard_comment.to_param, :moodboard_comment => valid_attributes}
        expect(response).to redirect_to(moodboard_item.moodboard)
      end
    end

    context "with invalid params" do
      it "assigns the moodboard_comment as @moodboard_comment" do
        moodboard_comment = MoodboardComment.create! valid_attributes
        put :update, {:id => moodboard_comment.to_param, :moodboard_comment => invalid_attributes}
        expect(assigns(:moodboard_comment)).to eq(moodboard_comment)
      end

      it "renders the 'moodboard' template" do
        moodboard_comment = MoodboardComment.create! valid_attributes
        put :update, {:id => moodboard_comment.to_param, :moodboard_comment => invalid_attributes}, valid_session
        expect(response.location).to redirect_to(moodboard_item.moodboard)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested moodboard_comment" do
      moodboard_comment = MoodboardComment.create! valid_attributes
      expect {
        delete :destroy, {:id => moodboard_comment.to_param}
      }.to change(MoodboardComment, :count).by(-1)
    end

    it "redirects to the Moodboard list" do
      moodboard_comment = MoodboardComment.create! valid_attributes
      delete :destroy, {:id => moodboard_comment.to_param}
      expect(response).to redirect_to(moodboard_item.moodboard)
    end
  end

end
