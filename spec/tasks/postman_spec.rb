# frozen_string_literal: true

require_relative '../../lib/tasks/postman'

RSpec.describe Tasks::Postman do
  subject(:postman) { described_class.new }

  describe '.initalize' do
    context 'when no errors are raised' do
      before do
        allow_any_instance_of(Object).to receive(:`).and_return(nil)
      end

      it 'initalizes without error' do
        expect { described_class.new }.not_to raise_error
      end
    end

    context 'when errors are raised' do
      before do
        allow_any_instance_of(Object).to receive(:`).and_raise(StandardError, 'error')
        allow(Config).to receive(:logger).and_return('logger')
      end

      it 'exits with the correct code' do
        expect { described_class.new }.to raise_error SystemExit
      end
    end
  end

  describe '#process' do


    context 'when no errors' do
      before do
        `cp spec/fixtures/postman_success_result.txt postman_result`
        allow(Config).to receive(:logger).and_return('logger')
      end

      after do
        `rm postman_result`
      end

      it 'processes the result' do
        expect(postman.process).to eq 'logger'
      end
    end

    context 'when errors failure errors' do
      before do
        `cp spec/fixtures/postman_failure_result.txt postman_result`
        allow(Config).to receive(:logger).and_return('logger')
      end

      after do
        `rm postman_result`
      end

      it 'raises system error' do
        expect { postman.process }.to raise_error SystemExit
      end
    end

    context 'when errors failure errors' do
      before do
        `cp spec/fixtures/postman_failure_result.txt postman_result`
        allow(Config).to receive(:logger).and_return('logger')
      end

      after do
        `rm postman_result`
      end

      it 'raises system error' do
        postman.instance_variable_set(:@iterations, {})
        expect { postman.process }.to raise_error SystemExit
      end
    end
  end
end