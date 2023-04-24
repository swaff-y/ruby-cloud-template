# frozen_string_literal: true

require_relative '../mongo_client_shared_context'
require_relative './shared_context_spec'
require_relative '../../lib/models/person'

RSpec.describe Models::Person do
  include_context 'models'
  let(:expected_schema) do
    {
      firstname: {
        type: String,
        required: true,
        description: 'A description'
      },
      lastname: {
        type: String,
        required: true,
        description: 'A description'
      },
      fullname: {
        type: String,
        required: true,
        unique: true,
        description: 'A description'
      },
      weight: {
        type: Integer,
        required: true,
        description: 'A description'
      },
      height: {
        type: Integer,
        required: true,
        description: 'A description'
      }
    }
  end

  describe '.initalize' do
    include_context 'mongo_client'

    it 'initalizes without error' do
      expect { model }.not_to raise_error
    end
  end

  describe '#schema' do
    include_context 'mongo_client'
    
    it 'returns the expected schema' do
      expect(model.schema).to eq expected_schema
    end
  end
end