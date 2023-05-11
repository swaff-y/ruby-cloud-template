# frozen_string_literal: true

def body
  {
    'description' => '',
    'required' => true,
    'content' => {
      'application/json' => {
        'schema' => {
          'type' => 'object',
          'properties' => {
            'firstname' => {
              'description' => 'The persons firstname',
              'type' => 'string'
            },
            'lastname' => {
              'description' => 'The persons lastname',
              'type' => 'string'
            },
            'weight' => {
              'description' => 'The persons weight',
              'type' => 'string'
            },
            'height' => {
              'description' => 'The persons height',
              'type' => 'string'
            }
          }
        }
      }
    }
  }
end
