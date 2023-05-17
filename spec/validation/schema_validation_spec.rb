# frozen_string_literal: true

require_relative '../../lib/validation/schema_validation'

RSpec.describe Validation::SchemaValidation do
  let(:model) { double(:model) }
  let(:hash) do
    {}
  end
  let(:schema) do
    {
      key: { 
        type: String,
        required: true,
        unique: true 
      },
      next_key: {
        type: String,
        required: false,
        unique: false
      }
    }
  end

  describe '.validate_hash_on_schema' do
    context 'when no key' do
      before do
        allow(described_class).to receive(:nil_required?).and_return(true)
        allow(described_class).to receive(:type_valid?).and_return(false)
        allow(described_class).to receive(:nil_unique?).and_return(false)
      end

      it 'raises an error' do
        expect { described_class.validate_hash_on_schema(hash, schema, model, 'post') }.to raise_error Exceptions::SchemaError, '{"key":"key is a required value","next_key":"next_key is a required value"}'
      end
    end

    context 'when type valid' do
      before do
        allow(described_class).to receive(:nil_required?).and_return(false)
        allow(described_class).to receive(:type_valid?).and_return(true)
        allow(described_class).to receive(:nil_unique?).and_return(false)
      end

      it 'raises an error' do
        expect { described_class.validate_hash_on_schema(hash, schema, model, 'post') }.to raise_error Exceptions::SchemaError, '{"key":"key is not a String","next_key":"next_key is not a String"}'
      end
    end

    context 'when nil unique' do
      before do
        allow(described_class).to receive(:nil_required?).and_return(false)
        allow(described_class).to receive(:type_valid?).and_return(false)
        allow(described_class).to receive(:nil_unique?).and_return(true)
        allow(described_class).to receive(:check_unique).and_return('yes')
      end

      it 'returns nil' do
        expect(described_class.validate_hash_on_schema(hash, schema, model, 'post')).to be_nil
      end
    end

    context 'when no errors' do
      before do
        allow(described_class).to receive(:nil_required?).and_return(false)
        allow(described_class).to receive(:type_valid?).and_return(false)
        allow(described_class).to receive(:nil_unique?).and_return(false)
      end

      it 'returns nil' do
        expect(described_class.validate_hash_on_schema(hash, schema, model, 'post')).to be_nil
      end
    end
  end

  describe '.validate_values_on_schema' do
    context 'when invalid values are empty' do
      it 'raises an error' do
        hash[:no_key] = 'fake value'
        expect { described_class.validate_values_on_schema(hash, schema) }.to raise_error Exceptions::SchemaError, '{"no_key":"no_key is not a valid search parameter"}'
      end
    end
    
    context 'when invalid values are not empty' do
      it 'returns nil' do
        expect(described_class.validate_values_on_schema(hash, schema)).to be_nil
      end
    end
  end

  describe '.nil_requred?' do
    context 'when key of hash is nil and schema key is not required' do
      it 'returns false' do
        hash[:next_key] = nil
        expect(described_class.nil_required?(hash, schema, :next_key)).to be false
      end
    end

    context 'when key of hash is nil and schema key is required' do
      it 'returns true' do
        hash[:key] = nil
        expect(described_class.nil_required?(hash, schema, :key)).to be true
      end
    end

    context 'when hash key is not nil' do
      it 'returns true' do
        hash[:key] = 'value'
        expect(described_class.nil_required?(hash, schema, :key)).to be true
      end
    end
  end

  describe '.nil_unique?' do
    context 'when key of hash is not nil and schema key  is not unique' do
      it 'returns false' do
        hash[:next_key] = 'value'
        expect(described_class.nil_unique?(hash, schema, :next_key)).to be false
      end
    end

    context 'when key of hash is not nil and schema key is unique' do
      it 'returns true' do
        hash[:key] = 'value'
        expect(described_class.nil_unique?(hash, schema, :key)).to be false
      end
    end

    context 'when hash key is nil' do
      it 'returns true' do
        hash[:key] = nil
        expect(described_class.nil_unique?(hash, schema, :key)).to be false
      end
    end
  end

  describe '.type_valid?' do
    context 'when key of hash is nil' do
      it 'returns false' do
        hash[:next_key] = nil
        expect(described_class.type_valid?(hash, schema, :next_key)).to be false
      end
    end

    context 'when key of hash is not nil and hash key is of the correct type' do
      it 'returns true' do
        hash[:next_key] = 'value'
        expect(described_class.type_valid?(hash, schema, :next_key)).to be true
      end
    end
  end

  describe '.check_unique' do
    context 'when record found' do
      let(:model) { double(:model, model: double(:model_ins, collection: double(:collection, find: { test: 'object' }))) }

      it 'returns correct value' do
        expect(described_class.check_unique({}, :next_key, model, hash)).to eq 'next_key already exists'
      end
    end

    context 'when record not found' do
      let(:model) { double(:model, model: double(:model_ins, collection: double(:collection, find: nil))) }

      it 'returns nil' do
        expect(described_class.check_unique({}, :next, model, hash)).to be_nil
      end
    end
  end
end