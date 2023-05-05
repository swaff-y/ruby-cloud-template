# frozen_string_literal: true

require_relative '../lib/config'

RSpec.describe Config do
  let(:klass) { described_class }

  describe '.logger' do
    let(:logger_methods) do
      {
        info: 'info log message',
        debug: 'debug log message',
        error: 'error log message'
      }
    end
    let(:logger) { instance_double(Logger, logger_methods) }

    context 'when info log' do
      before do
        allow(Logger).to receive(:new).and_return(logger)
      end

      it { expect(klass.logger('info', 'error message')).to eq 'info log message' }
    end

    context 'when debug log' do
      context 'when prod' do
        before do
          allow(Logger).to receive(:new).and_return(logger)
          allow(klass).to receive(:prod?).and_return(true)
        end

        it { expect(klass.logger('debug', 'error message')).to be_nil }
      end

      context 'when not prod' do
        before do
          allow(Logger).to receive(:new).and_return(logger)
          allow(klass).to receive(:prod?).and_return(false)
        end

        it { expect(klass.logger('debug', 'error message')).to eq 'debug log message' }
      end
    end

    context 'when error log' do
      before do
        allow(Logger).to receive(:new).and_return(logger)
      end

      it { expect(klass.logger('error', 'error message')).to eq 'error log message' }
    end
  end

  describe '.local?' do
    context 'when stage is local' do
      before { allow(klass).to receive(:stage).and_return('local') }
      it { expect(klass.local?).to be true }
    end

    context 'when stage is not local' do
      before { allow(klass).to receive(:stage).and_return('prod') }
      it { expect(klass.local?).to be_nil }
    end
  end

  describe '.prod?' do
    context 'when stage is prod' do
      before { allow(klass).to receive(:stage).and_return('prod') }
      it { expect(klass.prod?).to be true }
    end

    context 'when stage is not prod' do
      before { allow(klass).to receive(:stage).and_return('local') }
      it { expect(klass.prod?).to be_nil }
    end
  end

  describe '.stage' do
    context 'when stage env is nil' do
      before { allow(ENV).to receive(:fetch).and_return(nil) }
      it { expect(klass.stage).to eq nil}
    end

    context 'when stage env is not nil' do
      before { allow(ENV).to receive(:fetch).and_return('dev') }
      it { expect(klass.stage).to eq 'dev' }
    end
  end

  describe '.mongo_client' do
    before do 
      allow(Mongo::Client).to receive(:new).and_return('client')
      allow(klass).to receive(:mongo_url).and_return('http://a-fake-url.com')
    end

    it { expect(klass.mongo_client).to eq 'client'}
  end

  describe '.mongo_url' do
    before do
      allow(ENV).to receive(:fetch).and_return('http://a-fake-url.com')
      allow(Aws::SecretsManager::Client).to receive(:new).and_return(double(:aws, get_secret_value: double(:get_value, secret_string: "{\"DB_CONNECTION_STRING\":\"http://fake.com\"}") ))
    end

    it { expect(klass.mongo_url).to eq 'http://a-fake-url.com'}
  end

end