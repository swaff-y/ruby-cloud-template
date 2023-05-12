# frozen_string_literal: true

require 'json'
require_relative '../responses'
require_relative '../controllers/status'
require_relative '../controllers/person'
require_relative '../controllers/swagger'
require_relative './responses'
require_relative './parameters'
require_relative './security'
require_relative './request_body'

def api_status(event:, context:)
  if event
    status = Controllers::Status.new(event, context)
    status.get
  else
    {
      'summary' => "Check the api's status",
      'description' => "A status endpoint to check the API's status",
      'security' => security,
      'responses' => {
        '200' => _200(status_response),
        '400' => _400,
        '500' => _500
      }
    }
  end
end

def swagger_status(event:, context:)
  if event
    swagger = Controllers::Swagger.new(event, context)
    swagger.get
  else
    {
      'summary' => "Api's swagger documentation",
      'description' => "An endpoint to get the API's swagger yaml",
      'security' => security,
      'responses' => {
        '200' => _200(status_response),
        '400' => _400,
        '500' => _500
      }
    }
  end
end

def get_person_by_id(event:, context:)
  if event
    person = Controllers::Person.new(event, context)
    person.get_by_id
  else
    {
      'summary' => 'Get a person using thier ID',
      'description' => 'This endpoint gets a persons details with thier db ID',
      'security' => security,
      'parameters' => shared_path_parameters,
      'responses' => {
        '200' => _200(shared_data_response),
        '400' => _400,
        '500' => _500
      }
    }
  end
end

def get_person(event:, context:)
  if event
    person = Controllers::Person.new(event, context)
    person.get
  else
    {
      'summary' => 'Get a persons details',
      'description' => 'Get an array of persons matching filter data. i.e. weight or height. Also supports searching on firstname, lastname and fullname',
      'security' => security,
      'parameters' => shared_request_parameters,
      'responses' => {
        '200' => _200(shared_data_response),
        '400' => _400,
        '500' => _500
      }
    }
  end
end

def post_person(event:, context:)
  if event
    person = Controllers::Person.new(event, context)
    person.post
  else
    {
      'summary' => 'Add a new person',
      'description' => 'Adds a new person to the database',
      'security' => security,
      'requestBody' => body,
      'responses' => {
        '200' => _200(shared_data_response),
        '400' => _400,
        '500' => _500
      }
    }
  end
end

def put_person(event:, context:)
  if event
    person = Controllers::Person.new(event, context)
    person.put
  else
    {
      'summary' => 'Update a persons details',
      'description' => 'Updates persons details in the database',
      'security' => security,
      'parameters' => shared_path_parameters,
      'requestBody' => body,
      'responses' => {
        '200' => _200(shared_data_response),
        '400' => _400,
        '500' => _500
      }
    }
  end
end

def delete_person(event:, context:)
  if event
    person = Controllers::Person.new(event, context)
    person.delete
  else
    {
      'summary' => 'Delete a person',
      'description' => 'Deletes a person from the database',
      'security' => security,
      'parameters' => shared_path_parameters,
      'responses' => {
        '200' => _200(shared_data_response),
        '400' => _400,
        '500' => _500
      }
    }
  end
end
