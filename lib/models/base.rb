# frozen_string_literal: true

require_relative '../config'
require_relative '../exceptions/exceptions'
require_relative '../validation/schema_validation'

module Models
  # base model class
  class Base
    def initialize(event, context)
      @event = event
      @context = context
    end

    def valid_hash?(hash)
      return if hash.nil?
      return unless hash.is_a?(Hash)

      true
    end

    def check_collection
      raise Exceptions::UninitializedCollectionError, 'Collection has not been initalized' if @collection.nil?
    end

    def hash_schema(hash, type)
      schema = @model.schema
      mapped_hash = {}

      case type
      when 'post'
        Validation::SchemaValidation.validate_hash_on_schema(hash, schema, self, 'post')
      when 'put'
        Validation::SchemaValidation.validate_hash_on_schema(hash, schema, self, 'put')
      when 'find'
        Validation::SchemaValidation.validate_values_on_schema(hash, schema)
      end

      schema.each_key do |key|
        mapped_hash[key] = hash[key.to_s] unless hash[key.to_s].nil?
      end

      raise Exceptions::InvalidParametersError, 'The query parameters provided are not valid' if mapped_hash.empty?

      mapped_hash
    end

    def find_by_id(id = nil)
      return if id.nil?

      check_collection

      @collection.find(_id: BSON::ObjectId(id)).first
    end

    def find(hash = nil)
      return unless valid_hash?(hash)

      check_collection
      hash = hash_schema(hash, 'find')

      @collection.find(hash).to_a
    end

    def post(hash = nil)
      return unless valid_hash?(hash)

      check_collection
      hash = hash_schema(hash, 'post')

      res = @collection.insert_one(hash)
      return res.inserted_id if res.n.positive?

      raise Exceptions::RecordNotCreatedError, 'Record could not be created'
    end

    def update(id, hash = nil)
      return unless valid_hash?(hash)

      check_collection
      hash = hash_schema(hash, 'put')

      res = @collection.update_one({ _id: BSON::ObjectId(id) }, :'$set' => hash) # rubocop: disable Style/HashSyntax
      return res.modified_count if res.n.positive?

      raise Exceptions::RecordNotCreatedError, 'Error updating record'
    end

    def delete(id = nil)
      return if id.nil?

      check_collection

      res = @collection.delete_one(_id: BSON::ObjectId(id))

      return res.deleted_count if res.n.positive?

      raise Exceptions::RecordNotCreatedError, 'Error deleting record'
    end
  end
end
