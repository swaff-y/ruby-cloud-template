# frozen_string_literal: true

require_relative '../config'
require_relative '../exceptions/exceptions'

module Tasks
  # base model class
  class Coverage
    def initialize
      pwd = `pwd`.chomp
      @cov_hash = JSON.parse(File.read("#{pwd}/coverage/.last_run.json"))
      coverage = @cov_hash.dig('result', 'line')
      @error_msg = "Code coverage: \033[1;37;41m #{coverage}% \033[0m. Please add more tests"
      @avg_msg = "Code coverage: \033[1;30;43m #{coverage}% \033[0m"
      @best_msg = "Code coverage: \033[1;30;42m #{coverage}% \033[0m"
    end

    def process
      raise Exceptions::CoverageError, @error_msg unless Config.correct_coverage?(@cov_hash)

      return Config.logger('info', "Code coverage: #{@best_msg}") if Config.best_coverage?(@cov_hash)

      Config.logger('info', @avg_msg)
    rescue Exceptions::CoverageError => e
      Config.logger('error', e.message)
      exit(1)
    end
  end
end
