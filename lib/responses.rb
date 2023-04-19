# frozen_string_literal: true

require 'json'

# Responses
class Responses
  class << self
    def _200(data)
      Config.logger('debug', '200 Response')
      return JSON.generate(response(data, 200)) if Config.local?

      {
        statusCode: 200,
        body: JSON.generate(response(data, 200))
      }
    end

    def _400(error)
      Config.logger('debug', '400 Response')
      return JSON.generate(response(error, 400)) if Config.local?

      {
        statusCode: 400,
        body: JSON.generate(response(error, 400))
      }
    end

    def _500(error)
      Config.logger('debug', '500 Response')
      return JSON.generate(response(error, 500)) if Config.local?

      {
        statusCode: 500,
        body: JSON.generate(response(error, 500))
      }
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
