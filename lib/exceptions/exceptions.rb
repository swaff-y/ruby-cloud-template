# frozen_string_literal: true

module Exceptions
  # Error class for invalid parameters
  class InvalidParametersError < StandardError; end
  # Error class for record could not be created
  class RecordNotCreatedError < StandardError; end
  # Error class for Uninitalized collection
  class UninitializedCollectionError < StandardError; end
end
