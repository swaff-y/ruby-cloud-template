# frozen_string_literal: true

require_relative '../exceptions/exceptions'

module Validation
  # Status controller
  class SchemaValidation
    def self.validate_hash_on_schema(hash, schema, model, type)
      invalid_values = {}

      schema.each_key do |key|
        # validate presence
        invalid_values[key] = "#{key} is a required value" if nil_required?(hash, schema, key) && type == 'post'

        # validate type
        invalid_values[key] = "#{key} is not a #{schema.dig(key, :type)}" if type_valid?(hash, schema, key)

        # validate uniqueness
        check_unique(invalid_values, key, model, hash) if nil_unique?(hash, schema, key)
      end

      raise Exceptions::SchemaError, invalid_values.to_json unless invalid_values.empty?
    end

    def self.validate_values_on_schema(hash, schema)
      invalid_values = {}

      hash.each_key do |key|
        invalid_values[key.to_sym] = "#{key} is not a valid search parameter" if schema[key.to_sym].nil?
      end

      raise Exceptions::SchemaError, invalid_values.to_json unless invalid_values.empty?
    end

    def self.nil_required?(hash, schema, key)
      hash[key.to_s].nil? && schema.dig(key, :required)
    end

    def self.nil_unique?(hash, schema, key)
      !hash[key.to_s].nil? && schema.dig(key, :unique)
    end

    def self.type_valid?(hash, schema, key)
      return false if hash[key].nil?

      schema.dig(key, :type) && !hash[key.to_s].is_a?(schema.dig(key, :type))
    end

    def self.check_unique(invalid_values, key, model, hash)
      invalid_values[key] = "#{key} already exists" if model.model.collection.find({ key => hash[key.to_s] }).to_a.length.positive?
    end
  end
end
