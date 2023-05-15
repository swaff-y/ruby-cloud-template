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

  describe '#hash_schema' do
    let(:schema) { { west: 'string' } }

    before do
      allow(Validation::SchemaValidation).to receive(:validate_hash_on_schema).and_return(true)
    end

    context 'when mapped hash is not empty' do
      let(:hash) { { 'west' => 'value' } }

      it 'returns the mapped hash' do
        model.instance_variable_set(:@model, double(:model, schema: schema))
        expect(model.hash_schema(hash, 'post')).to eq({ west: 'value' })
      end
    end

    context 'when mapped hash is empty' do
      let(:hash) { { west: 'value' } }

      it 'raises an error' do
        model.instance_variable_set(:@model, double(:model, schema: schema))
        expect { model.hash_schema(hash, 'post') }.to raise_error Exceptions::InvalidParametersError, 'The query parameters provided are not valid'
      end
    end

    context 'when type is put' do
      let(:hash) { { 'west' => 'value' } }

      it 'returns the mapped hash' do
        model.instance_variable_set(:@model, double(:model, schema: schema))
        expect(model.hash_schema(hash, 'put')).to eq({ west: 'value' })
      end
    end

    context 'when type is find' do
      let(:hash) { { 'west' => 'value' } }

      it 'returns the mapped hash' do
        model.instance_variable_set(:@model, double(:model, schema: schema))
        expect(model.hash_schema(hash, 'find')).to eq({ west: 'value' })
      end
    end
  end

  describe '#find_by_id' do
    before do
      allow(BSON).to receive(:ObjectId).and_return('Object id')
      allow_any_instance_of(described_class).to receive(:check_collection).and_return(true)
    end

    context 'when no ID' do
      it 'returns nil' do
        expect(model.find_by_id).to be_nil
      end
    end

    context 'when ID' do
      it 'returns found object' do
        model.instance_variable_set(:@collection, double(:collection, find: ['array', 'of', 'values']))
        expect(model.find_by_id('id')).to eq 'array'
      end
    end
  end

  describe '#find' do
    before do
      allow_any_instance_of(described_class).to receive(:check_collection).and_return(true)
      allow_any_instance_of(described_class).to receive(:hash_schema).and_return({})
    end

    context 'when no hash' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(false)
      end

      it 'returns nil' do
        expect(model.find).to be_nil
      end
    end

    context 'when valid hash' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(true)
      end

      it 'returns found object' do
        model.instance_variable_set(:@collection, double(:collection, find: ['array', 'of', 'values']))
        expect(model.find({})).to eq(["array", "of", "values"])
      end
    end
  end

  describe '#post' do
    before do
      allow_any_instance_of(described_class).to receive(:check_collection).and_return(true)
      allow_any_instance_of(described_class).to receive(:hash_schema).and_return({})
    end

    context 'when no hash' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(false)
      end

      it 'returns nil' do
        expect(model.post).to be_nil
      end
    end

    context 'when valid hash' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(true)
      end

      it 'returns found object' do
        model.instance_variable_set(:@collection, double(:collection, insert_one: double(:insert_one, n: 1, inserted_id: 'ID')))
        expect(model.post({})).to eq 'ID'
      end
    end

    context 'when bad response' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(true)
      end

      it 'returns found object' do
        model.instance_variable_set(:@collection, double(:collection, insert_one: double(:insert_one, n: 0)))
        expect { model.post({}) }.to raise_error Exceptions::RecordNotCreatedError, 'Record could not be created'
      end
    end
  end

  describe '#update' do
    before do
      allow_any_instance_of(described_class).to receive(:check_collection).and_return(true)
      allow_any_instance_of(described_class).to receive(:hash_schema).and_return({})
      allow(BSON).to receive(:ObjectId).and_return('ID')
    end

    context 'when no hash' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(false)
      end

      it 'returns nil' do
        expect(model.update('id')).to be_nil
      end
    end

    context 'when valid hash' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(true)
      end

      it 'returns found object' do
        model.instance_variable_set(:@collection, double(:collection, update_one: double(:update_one, n: 1, modified_count: 1)))
        expect(model.update('id', {})).to eq 1
      end
    end

    context 'when bad response' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(true)
      end

      it 'returns found object' do
        model.instance_variable_set(:@collection, double(:collection, update_one: double(:update_one, n: 0)))
        expect { model.update('id', {}) }.to raise_error Exceptions::RecordNotCreatedError, 'Error updating record'
      end
    end
  end

  describe '#delete' do
    before do
      allow_any_instance_of(described_class).to receive(:check_collection).and_return(true)
      allow_any_instance_of(described_class).to receive(:hash_schema).and_return({})
      allow(BSON).to receive(:ObjectId).and_return('ID')
    end

    context 'when no hash' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(false)
      end

      it 'returns nil' do
        expect(model.delete).to be_nil
      end
    end

    context 'when valid hash' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(true)
      end

      it 'returns found object' do
        model.instance_variable_set(:@collection, double(:collection, delete_one: double(:delete_one, n: 1, deleted_count: 1)))
        expect(model.delete('id')).to eq 1
      end
    end

    context 'when bad response' do
      before do
        allow_any_instance_of(described_class).to receive(:valid_hash?).and_return(true)
      end

      it 'returns found object' do
        model.instance_variable_set(:@collection, double(:collection, delete_one: double(:delete_one, n: 0)))
        expect { model.delete('id') }.to raise_error Exceptions::RecordNotCreatedError, 'Error deleting record'
      end
    end
  end
end