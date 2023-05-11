# frozen_string_literal: true

require 'yaml'
require 'json'
require_relative '../models/person'
require_relative '../config'
require_relative '../exceptions/exceptions'
require_relative '../lambda/handler'

module Tasks
  # Swagger constructor
  class Swagger
    attr_accessor :swagger, :swagger_yaml, :swagger_json

    def initialize
      @serverless_yml_hash = YAML.parse(File.read('serverless.yml')).to_ruby
      @swagger = {}
      version
      info
      servers
      paths
      components
      @swagger_yaml = @swagger.to_yaml
      @swagger_json = @swagger.to_json
    end

    def version
      @swagger['openapi'] = '3.0.0'
    end

    def info
      @swagger['info'] = {
        'title' => Config.application,
        'description' => Config.application_description,
        'version' => Config.version
      }
    end

    def servers
      @swagger['servers'] = [
        {
          'url' => 'http://127.0.0.1:4567',
          'description' => 'Server used for local development when sinatra server is running'
        },
        {
          'url' => 'https://<unique_id>.execute-api.ap-southeast-2.amazonaws.com/dev-CT-XXX',
          'description' => 'Devlopment server'
        },
        {
          'url' => 'https://4crc3u5fb5.execute-api.ap-southeast-2.amazonaws.com/prod',
          'description' => 'Production server'
        }
      ]
    end

    def paths
      @swagger['paths'] = retrieve_paths
    end

    def components
      @swagger['components'] = {
        'securitySchemes' => {
          'ApiKeyAuth' => {
            'type' => 'apiKey',
            'in' => 'header',
            'name' => 'X-API-Key'
          }
        }
      }
    end

    private

    def retrieve_paths
      paths = []
      methods = []
      @serverless_yml_hash['functions'].each do |key, value|
        paths << value.dig('events', 0, 'http', 'path')
        methods << {
          'path' => value.dig('events', 0, 'http', 'path'),
          'method' => value.dig('events', 0, 'http', 'method'),
          'method_name' => key
        }
      end
      path_hash = Hash[paths.collect { |v| [v, {}] }] # rubocop: disable Style/HashConversion

      methods.each do |value|
        endpoint_details = send(value['method_name'].to_sym, event: nil, context: nil)
        path_hash.each do |key|
          path_hash[value['path']].store(value['method'], endpoint_details) if value['path'] == key[0]
        end
      end
      path_hash
    end
  end
end
