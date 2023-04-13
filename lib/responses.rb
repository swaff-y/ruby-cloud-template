# frozen_string_literal: true

require 'json'

# Responses
class Responses
  class << self
    def _200(data)
      JSON.generate(response(data, 200))
    end

    def _400(error)
      JSON.generate(response(error, 400))
    end

    def _500(error)
      JSON.generate(response(error, 500))
    end

    private

    def response(data, code)
      case code
      when 200
        {
          status: 'success',
          data: data
        }
      when 400
        {
          status: 'fail',
          data: data
        }
      when 500
        {
          status: 'error',
          code: 500,
          message: data[:message],
          data: data[:backtrace]
        }
      end
    end
  end
end
