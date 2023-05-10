# frozen_string_literal: true

require 'yaml'
require_relative '../models/person'
require_relative '../config'
require_relative '../exceptions/exceptions'

module Tasks
  # Swagger constructor
  class Swagger
    attr_accessor :swagger, :swagger_yaml
    def initialize
      @swagger = {}
      version
      info
      servers
      paths
      @swagger_yaml = @swagger.to_yaml
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
          'url' => 'http://127.0.0.1:4567',
          'description' => 'Devlopment server'
        },
        {
          'url' => 'http://127.0.0.1:4567',
          'description' => 'Production server'
        }
      ]
    end

    def paths
      @swagger['paths'] = {
        '/status/{id}' => {
          'get' => {
            'summary' => 'A status endpoint',
            'parameters' => [
              {
                'in' => 'path',
                'name' => 'id',
                'description' => 'The id of the person',
                'required' => true,
                'schema' => {
                  'type' => 'string',
                }
              }
            ],
            'responses' => {
              '200' => {
                'description' => 'Success response',
                'content' => {
                  'application/json' => {
                    'schema' => {
                      'type' => 'object',
                      'items' => {
                        'type' => 'string'
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    end
  end
end