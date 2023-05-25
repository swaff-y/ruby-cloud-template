# frozen_string_literal: true

require_relative '../config'
require_relative '../exceptions/exceptions'

module Tasks
  # base model class
  class Postman
    def initialize
      @iterations = `cat postman_result | grep iterations`
      @requests = `cat postman_result | grep requests`
      @test_scripts = `cat postman_result | grep test-scripts`
      @prerequest_scripts = `cat postman_result | grep prerequest-scripts`
      @assertions = `cat postman_result | grep assertions`
    rescue StandardError => e
      Config.logger('error', "postman #{e.message}")
      exit(1)
    end

    def process
      results = []
      results << { type: 'iterations', result: @iterations.gsub(/\e\[..m|\n/, '')&.split('│')&.dig(3)&.strip&.to_i&.positive? }
      results << { type: 'requests', result: @requests.gsub(/\e\[..m|\n/, '')&.split('│')&.dig(3)&.strip&.to_i&.positive? }
      results << { type: 'test_scripts', result: @test_scripts.gsub(/\e\[..m|\n/, '')&.split('│')&.dig(3)&.strip&.to_i&.positive? }
      results << { type: 'prerequest_scripts', result: @prerequest_scripts.gsub(/\e\[..m|\n/, '')&.split('│')&.dig(3)&.strip&.to_i&.positive? }
      results << { type: 'assertions', result: @assertions.gsub(/\e\[..m|\n/, '')&.split('│')&.dig(3)&.strip&.to_i&.positive? }

      results.each do |result|
        raise Exceptions::PostmanError, "Postman Error: #{result[:type]}" if result[:result]
      end

      Config.logger('info', 'Postman passed')
    rescue Exceptions::PostmanError => e
      Config.logger('error', "Postman #{e.message}")
      exit(1)
    rescue StandardError => e
      Config.logger('error', "Proc #{e.message}")
      exit(1)
    end
  end
end
