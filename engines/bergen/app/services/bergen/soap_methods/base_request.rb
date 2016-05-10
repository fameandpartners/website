module Bergen
  module SoapMethods
    class BaseRequest
      def response
        raise NotImplementedError
      end

      def result
        raise NotImplementedError
      end
    end
  end
end
