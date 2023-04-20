# frozen_string_literal: true

require_relative './shared_context_spec'
require_relative '../../lib/controllers/person'

RSpec.describe Controllers::Person do
  include_context 'controllers'

  let(:event) do
    {
      'queryStringParameters' => {},
      'pathParameters' => {},
      'body' => ""
    }
  end

  let(:validation) { instance_double(Validation::Person, validate_get_by_id: 'validated') }
  let(:model) { instance_double(Models::Person, find_by_id: 'found person') }

  before do
    allow(Validation::Person).to receive(:new).and_return(validation)
    allow(Models::Person).to receive(:new).and_return(model)
    allow(Config).to receive(:logger).and_return('logged')
  end

  describe '.initalize' do
    it 'initalizes without error' do
      expect { controller }.not_to raise_error
    end
  end
 
  describe '#get_by_id' do
    before do
      allow_any_instance_of(described_class).to receive(:rec_log).and_return('rec log')
      allow(Responses).to receive(:_200).and_return('ok')
    end

    it 'returns a 200 response' do
      expect(controller.get_by_id).to eq 'ok'
    end

    context 'when InvalidParametersError' do
      before do
        allow(validation).to receive(:validate_get_by_id).and_raise(Exceptions::InvalidParametersError, 'An error')
        allow(Responses).to receive(:_400).and_return('400 invalid params')
      end

      it 'returns a 400 response' do
        expect(controller.get_by_id).to eq '400 invalid params'
      end
    end

    context 'when ObjectId::Invalid' do
      before do
        allow(validation).to receive(:validate_get_by_id).and_raise(BSON::ObjectId::Invalid, 'An error')
        allow(Responses).to receive(:_400).and_return('400 invalid id')
      end

      it 'returns a 400 response' do
        expect(controller.get_by_id).to eq '400 invalid id'
      end
    end

    context 'when StandardError' do
      before do
        allow(validation).to receive(:validate_get_by_id).and_raise(StandardError, 'An error')
        allow(Responses).to receive(:_500).and_return('500 error')
      end

      it 'returns a 500 response' do
        expect(controller.get_by_id).to eq '500 error'
      end
    end
  end
end