# frozen_string_literal: true

def shared_path_parameters
  [
    {
      'in' => 'path',
      'name' => 'id',
      'required' => true,
      'schema' => {
        'type' => 'string',
        'description' => 'Persons db id'
      }
    }
  ]
end

def shared_request_parameters
  [
    {
      'in' => 'query',
      'name' => 'firstname',
      'schema' => {
        'type' => 'string',
        'description' => 'Persons firstname'
      }
    },
    {
      'in' => 'query',
      'name' => 'lastname',
      'schema' => {
        'type' => 'string',
        'description' => 'Persons lastname'
      }
    },
    {
      'in' => 'query',
      'name' => 'fulltname',
      'schema' => {
        'type' => 'string',
        'description' => 'Persons fullname'
      }
    },
    {
      'in' => 'query',
      'name' => 'weight',
      'schema' => {
        'type' => 'string',
        'description' => 'A Persons weight'
      }
    },
    {
      'in' => 'query',
      'name' => 'height',
      'schema' => {
        'type' => 'string',
        'description' => 'A Persons height'
      }
    }
  ]
end
