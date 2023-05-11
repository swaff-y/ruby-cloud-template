# frozen_string_literal: true

def _200(data_schema)
  {
    'description' => 'Success response',
    'content' => {
      'application/json' => {
        'schema' => {
          'type' => 'object',
          'properties' => {
            'status' => {
              'type' => 'string'
            },
            'data' => data_schema
          }
        }
      }
    }
  }
end

def _400
  {
    'description' => 'Failure response',
    'content' => {
      'application/json' => {
        'schema' => {
          'type' => 'object',
          'properties' => {
            'status' => {
              'type' => 'string'
            },
            'data' => {
              'type' => 'string'
            }
          }
        }
      }
    }
  }
end

def _500
  {
    'description' => 'Internal error response',
    'content' => {
      'application/json' => {
        'schema' => {
          'type' => 'object',
          'properties' => {
            'status' => {
              'type' => 'string'
            },
            'data' => {
              'type' => 'string'
            }
          }
        }
      }
    }
  }
end

def shared_data_response
  {
    'type' => 'object',
    'properties' => {
      'firstname' => {
        'type' => 'string'
      },
      'lastname' => {
        'type' => 'string'
      },
      'fullname' => {
        'type' => 'string'
      },
      'weight' => {
        'type' => 'string'
      },
      'height' => {
        'type' => 'string'
      }
    }
  }
end

def status_response
  {
    'type' => 'object',
    'properties' => {
      'status' => {
        'type' => 'string'
      },
      'database' => {
        'type' => 'string'
      },
      'stage' => {
        'type' => 'string'
      }
    }
  }
end
