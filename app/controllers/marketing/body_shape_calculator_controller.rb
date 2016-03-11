module Marketing
  class BodyShapeCalculatorController < ActionController::Base

    layout false

    def show
      # NOOP
    end

    def store_measures
      @measure = BodyCalculatorMeasure.new(params[:body_calculator_measure])

      respond_to do |format|
        format.json do
          if @measure.save
            render json: { saved: :ok }
          else
            render json: { errors: @measure.errors }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
