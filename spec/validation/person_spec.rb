# frozen_string_literal: true

require_relative '../../lib/validation/person'

RSpec.describe Validation::Person do
  subject(:status) { described_class.new(event, context) }

  let(:event) do
    {
      'pathParameters' => {
        'id' => '123'
      },
      'queryStringParameters' => {
        'firstname' => 'Tom',
        'lastname' => 'Sawyer',
      },
      'body' => '{ "firstname":"Tom", "lastname":"Sawyer" }'
    }
  end

  let(:context) do
    {
      context_key: 'context value'
    }
  end

  describe '.initalize' do
    let(:expected_response) do
      {
        'firstname' => 'Tom',
        'lastname' => 'Sawyer'
      }
    end

    it 'initalizes wthout error' do
      expect { subject }.not_to raise_error
      expect(subject.instance_variable_get(:@event)).to eq event
      expect(subject.instance_variable_get(:@context)).to eq context
      expect(subject.instance_variable_get(:@path_parameters)).to eq event['pathParameters']
      expect(subject.instance_variable_get(:@query_string_parameters)).to eq event['queryStringParameters']
      expect(subject.instance_variable_get(:@body)).to eq expected_response
    end
  end

  describe '#validate_get_by_id' do
    context 'when id in path is nil' do
      it 'raises the correct error' do
        subject.instance_variable_set(:@path_parameters, { 'id' => nil })
        expect { subject.validate_get_by_id }.to raise_error Exceptions::InvalidParametersError, 'Parameters missing: ID'
      end
    end

    context 'when id in path is not nil' do
      it 'returns nil' do
        expect(subject.validate_get_by_id).to be_nil
      end
    end
  end

  describe '#validate_get' do
    context 'when query parameters are nil' do
      it 'raises the correct error' do
        subject.instance_variable_set(:@query_string_parameters, {})
        expect { subject.validate_get }.to raise_error Exceptions::InvalidParametersError, 'Parameters missing: No request parameters'
      end
    end

    context 'when query parameters are not nil' do
      it 'returns nil' do
        expect(subject.validate_get).to be_nil
      end
    end
  end

  describe '#validate_post' do
    context 'when body is nil' do
      it 'raises the correct error' do
        subject.instance_variable_set(:@body, nil)
        expect { subject.validate_post }.to raise_error Exceptions::InvalidParametersError, 'Parameters missing: No body'
      end
    end

    context 'when body is not nil' do
      it 'returns nil' do
        expect(subject.validate_post).to be_nil
      end
    end
  end

  describe '#validate_put' do
    context 'when body is nil' do
      it 'raises the correct error' do
        subject.instance_variable_set(:@body, nil)
        expect { subject.validate_put }.to raise_error Exceptions::InvalidParametersError, 'Parameters missing: No body'
      end
    end

    context 'when query parameters are nil' do
      it 'raises the correct error' do
        subject.instance_variable_set(:@path_parameters, { 'id' => nil })
        expect { subject.validate_put }.to raise_error Exceptions::InvalidParametersError, 'Parameters missing: ID'
      end
    end

    context 'when body is not nil' do
      it 'returns nil' do
        expect(subject.validate_put).to be_nil
      end
    end
  end

  describe '#validate_delete' do
    context 'when id in path is nil' do
      it 'raises the correct error' do
        subject.instance_variable_set(:@path_parameters, { 'id' => nil })
        expect { subject.validate_delete }.to raise_error Exceptions::InvalidParametersError, 'Parameters missing: ID'
      end
    end

    context 'when id in path is not nil' do
      it 'returns nil' do
        expect(subject.validate_delete).to be_nil
      end
    end
  end
end