# frozen_string_literal: true

require_relative '../config'
require_relative '../exceptions/exceptions'

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

    def correct_hash(hash)
      mapped_hash = @model.map(hash)

      mapped_hash.each_key do |key|
        mapped_hash.delete(key) if hash[key].nil?
      end

      raise Exceptions::InvalidParametersError, 'The query parameters provided are not valid' if mapped_hash.empty?

      mapped_hash
    end

    def find_by_id(id = nil)
      return if id.nil?

      check_collection

      @collection.find(:_id => BSON::ObjectId(id)).first
    end

    def find(hash = nil)
      return unless valid_hash?(hash)

      check_collection
      hash = correct_hash(hash)

      @collection.find(hash).to_a
    end

    def create(hash = nil)
      return unless valid_hash?(hash)

      hash
    end

    def delete(hash = nil)
      return unless valid_hash?(hash)

      hash
    end

    def update(hash = nil)
      return unless valid_hash?(hash)

      hash
    end
  end
end
