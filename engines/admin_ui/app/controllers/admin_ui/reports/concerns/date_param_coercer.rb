module AdminUi
  module Reports
    module Concerns
      module DateParamCoercer
        private def default_from_date
          6.weeks.ago
        end

        private def default_to_date
          Date.today
        end

        private def from_date
          normalize_date(params[:from], default: default_from_date)
        end

        private def to_date
          normalize_date(params[:to], default: default_to_date)
        end

        private def normalize_date(parameter, default: default)
          if parameter.present?
            Date.parse(parameter.to_s).to_date
          else
            default
          end
        rescue StandardError => _
          default
        end
      end
    end
  end
end
