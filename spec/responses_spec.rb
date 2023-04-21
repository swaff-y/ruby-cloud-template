# frozen_string_literal: true

require_relative '../lib/config'

RSpec.describe Responses do
  let(:klass) { described_class }

  before do 
    allow(Config).to receive(:logger).and_return('logger')
    allow(JSON).to receive(:generate).and_return('generated json')
  end

  describe '._200' do
    let(:expected_response) do
      {
        statusCode: 200,
        body: 'generated json'
      }
    end
    before { allow(klass).to receive(:response).and_return('response') }

    context 'when local' do
      before { allow(Config).to receive(:local?).and_return(true) }
      it { expect(klass._200('data')).to eq 'generated json' }
    end

    context 'when not local' do
      before { allow(Config).to receive(:local?).and_return(false) }
      it { expect(klass._200('data')).to eq expected_response }
    end
  end

  describe '._400' do
    let(:expected_response) do
      {
        statusCode: 400,
        body: 'generated json'
      }
    end
    before { allow(klass).to receive(:response).and_return('response') }

    context 'when local' do
      before { allow(Config).to receive(:local?).and_return(true) }
      it { expect(klass._400('data')).to eq 'generated json' }
    end

    context 'when not local' do
      before { allow(Config).to receive(:local?).and_return(false) }
      it { expect(klass._400('data')).to eq expected_response }
    end
  end

  describe '._500' do
    let(:expected_response) do
      {
        statusCode: 500,
        body: 'generated json'
      }
    end
    before { allow(klass).to receive(:response).and_return('response') }

    context 'when local' do
      before { allow(Config).to receive(:local?).and_return(true) }
      it { expect(klass._500('data')).to eq 'generated json' }
    end

    context 'when not local' do
      before { allow(Config).to receive(:local?).and_return(false) }
      it { expect(klass._500('data')).to eq expected_response }
    end
  end

  describe '.response' do
    let(:data) do
      {
        message: 'error message',
        backtrace: 'error backtrace'
      }
    end

    context 'when 200' do
      let(:expected_response) do
        {
          status: 'success',
          data: data
        }
      end

      it { expect(klass.send(:response, data, 200)).to eq expected_response }
    end

    context 'when 400' do
      let(:expected_response) do
        {
          status: 'fail',
          data: data
        }
      end

      it { expect(klass.send(:response, data, 400)).to eq expected_response }
    end

    context 'when 500' do
      let(:expected_response) do
        {
          status: 'error',
          code: 500,
          message: data[:message],
          data: data[:backtrace]
        }
      end

      it { expect(klass.send(:response, data, 500)).to eq expected_response }
    end
  end
end