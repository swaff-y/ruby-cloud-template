# frozen_string_literal: true

require 'json'
require_relative '../responses'
require_relative '../controllers/status'
require_relative '../controllers/person'

def api_status(event:, context:)
  status = Controllers::Status.new(event, context)
  status.get
end

def get_person_by_id(event:, context:)
  person = Controllers::Person.new(event, context)
  person.get_by_id
end

def get_person(event:, context:)
  person = Controllers::Person.new(event, context)
  person.get
end

def post_person(event:, context:)
  person = Controllers::Person.new(event, context)
  person.post
end

def put_person(event:, context:)
  person = Controllers::Person.new(event, context)
  person.put
end

def delete_person(event:, context:)
  person = Controllers::Person.new(event, context)
  person.delete
end
