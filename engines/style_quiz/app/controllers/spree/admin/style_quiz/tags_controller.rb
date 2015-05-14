module Spree::Admin::StyleQuiz
  class TagsController < Spree::Admin::StyleQuiz::BaseController
    def index
      @tags = ::StyleQuiz::Tag.all.sort_by {|tag| [10 - tag.weight, tag.name]}
    end

    def new
    end

    def create
    end

    def edit
      @tag = ::StyleQuiz::Tag.find(params[:id])
    end

    def update
      @tag = ::StyleQuiz::Tag.find(params[:id])
      @tag.assign_attributes(params[:tag])
      if @tag.save
        redirect_to admin_style_quiz_tags_path
      else
        render action: 'edit'
      end
    end

    def destroy
      # check tag relationships to products & other things, not destroy if any exists
    end

    private
      
      def model_class
        ::StyleQuiz::Tag
      end
  end
end
