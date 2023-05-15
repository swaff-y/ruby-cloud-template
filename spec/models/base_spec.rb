# frozen_string_literal: true

require_relative '../mongo_client_shared_context'
require_relative './shared_context_spec'
require_relative '../../lib/models/person'

RSpec.describe Models::Base do
  include_context 'models'

  describe '#valid_hash' do
    context 'when a valid hash' do
      it 'returns true' do
        expect(model.valid_hash?({})).to be true
      end
    end

    context 'when an invalid hash' do
      it 'returns nil' do
        expect(model.valid_hash?(nil)).to be_nil
        expect(model.valid_hash?('string')).to be_nil
      end
    end
  end

  describe '#check_collection' do
    context 'when no collection' do
      it 'raises an error' do
        model.instance_variable_set(:@collection, nil)
        expect { model.check_collection }.to raise_error Exceptions::UninitializedCollectionError, 'Collection has not been initalized' 
      end
    end

    context 'when there is a collection' do
      it 'returns nil' do
        model.instance_variable_set(:@collection, 'a collection')
        expect(model.check_collection).to be_nil
      end
    end
  end
end