# frozen_string_literal: true

require_relative './shared_context_spec'
require_relative '../../lib/controllers/person'

RSpec.describe Controllers::Person do
  include_context 'controllers'

  let(:validation) { instance_double(Validation::Person, validation_methods) }
  let(:model) { instance_double(Models::Person, model_methods) }

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
    context 'when no errors' do
      include_context '200 allow'

      it 'returns a 200 response' do
        expect(controller.get_by_id).to eq 'ok'
      end
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

  describe "#get" do
    context 'when no errors' do
      include_context '200 allow'

      it 'returns a 200 response' do
        expect(controller.get).to eq 'ok'
      end
    end

    context 'when InvalidParametersError' do
      before do
        allow(validation).to receive(:validate_get).and_raise(Exceptions::InvalidParametersError, 'An error')
        allow(Responses).to receive(:_400).and_return('400 invalid params')
      end

      it 'returns a 400 response' do
        expect(controller.get).to eq '400 invalid params'
      end
    end

    context 'when StandardError' do
      before do
        allow(validation).to receive(:validate_get).and_raise(StandardError, 'An error')
        allow(Responses).to receive(:_500).and_return('500 error')
      end

      it 'returns a 500 response' do
        expect(controller.get).to eq '500 error'
      end
    end
  end

  describe "#post" do
    context 'when no errors' do
      include_context '200 allow'

      it 'returns a 200 response' do
        expect(controller.post).to eq 'ok'
      end
    end

    context 'when InvalidParametersError' do
      before do
        allow(validation).to receive(:validate_post).and_raise(Exceptions::InvalidParametersError, 'An error')
        allow(Responses).to receive(:_400).and_return('400 invalid params')
      end

      it 'returns a 400 response' do
        expect(controller.post).to eq '400 invalid params'
      end
    end

    context 'when SchemaError' do
      before do
        allow(validation).to receive(:validate_post).and_raise(Exceptions::SchemaError, {'error' => 'error'}.to_json)
        allow(Responses).to receive(:_400).and_return('400 error')
      end

      it 'returns a 400 response' do
        expect(controller.post).to eq '400 error'
      end
    end

    context 'when RecordNotCreatedError' do
      before do
        allow(validation).to receive(:validate_post).and_raise(Exceptions::RecordNotCreatedError, 'An error')
        allow(Responses).to receive(:_500).and_return('500 error')
      end

      it 'returns a 500 response' do
        expect(controller.post).to eq '500 error'
      end
    end

    context 'when StandardError' do
      before do
        allow(validation).to receive(:validate_post).and_raise(StandardError, 'An error')
        allow(Responses).to receive(:_500).and_return('500 error')
      end

      it 'returns a 500 response' do
        expect(controller.post).to eq '500 error'
      end
    end
  end
end