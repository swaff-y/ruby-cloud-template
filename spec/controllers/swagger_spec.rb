# frozen_string_literal: true

require_relative '../../lib/controllers/swagger'

RSpec.describe Controllers::Swagger do
  subject(:controller) { described_class.new('event', 'context') }

  let(:json) do
    "{\"this\":\"is json\"}"
  end

  let(:swagger_processor) { double(:swagger_processor, process: swagger) }
  let(:swagger) { double(:swagger, swagger: json) }

  before do
    allow(Processors::SwaggerProcessor).to receive(:new).and_return(double(:swagger_processor, process: double(:swagger, swagger: json)))
    allow(Time).to receive(:now).and_return(1234)
  end

  describe '.initalize' do
    it 'initalizes without error' do
      expect { controller }.not_to raise_error
    end
  end

  describe '#get' do
    before do
      allow(Config).to receive(:logger).and_return('logger')
      allow(JSON).to receive(:generate).and_return(json)
      allow(ChronicDuration).to receive(:output).and_return('chronic output')
    end

    context 'when local' do
      before do
        allow(Config).to receive(:local?).and_return(true)
      end

      it 'returns the correct log' do
        expect(controller.get).to eq json
      end
    end

    context 'when not local' do
      let(:expected) do
        {
          body: "{\"this\":\"is json\"}",
          statusCode: 200
        }
      end

      before do
        allow(Config).to receive(:local?).and_return(false)
      end

      it 'returns the correct hash' do
        expect(controller.get).to eq expected
      end
    end

    context 'when error' do
      before do
        allow(Responses).to receive(:_500).and_return('500 response')
        allow(Config).to receive(:local?).and_raise(StandardError, 'An error')
      end

      it 'returns the correct response' do
        expect(controller.get).to eq '500 response'
      end
    end
  end
end