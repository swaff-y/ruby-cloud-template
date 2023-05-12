# frozen_string_literal: true

require_relative '../../lib/controllers/status'

RSpec.describe Controllers::Status do
  subject(:controller) { described_class.new('event', 'context') }

  let(:status_validation) { instance_double(Validation::Status, validation_methods) }
  let(:validation_methods) do
    {
      process: 'cloud_template'
    }
  end

  before do
    allow(Validation::Status).to receive(:new).and_return(status_validation)
  end

  describe '.initalize' do
    it 'initalizes without error' do
      expect { described_class.new('event', 'context') }.not_to raise_error
    end
  end

  describe '#get' do
    before do
      allow(Config).to receive(:logger).and_return('logged')
      allow(Responses).to receive(:_200).and_return('ok')
    end

    it 'returns the correct response' do
      expect(controller.get).to eq 'ok'
    end

    context 'when connection error' do
      before do
        allow(Responses).to receive(:_200).and_raise(Exceptions::ConnectionError, 'error')
        allow(Responses).to receive(:_500).and_return('error')
      end

      it 'returns the correct response' do
        expect(controller.get).to eq 'error'
      end
    end

    context 'when standard error' do
      before do
        allow(Responses).to receive(:_200).and_raise(StandardError, 'error')
        allow(Responses).to receive(:_500).and_return('error')
      end

      it 'returns the correct response' do
        expect(controller.get).to eq 'error'
      end
    end
  end
end