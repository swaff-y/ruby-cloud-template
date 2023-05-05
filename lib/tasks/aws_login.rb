# frozen_string_literal: true

require_relative '../config'
require_relative '../exceptions/exceptions'

module Tasks
  # base model class
  class AwsLogin
    def initialize
      @account = Config.account
    end

    def process
      cmd = "aws ecr get-login-password | docker login --username AWS --password-stdin #{@account}.dkr.ecr.ap-southeast-2.amazonaws.com"
      `#{cmd}`
    rescue StandardError => e
      Config.logger('error', e.message)
      exit(1)
    end
  end
end
