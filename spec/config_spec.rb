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

  describe '.dev?' do
    context 'when stage is dev' do
      before { allow(klass).to receive(:stage).and_return('dev') }
      it { expect(klass.dev?).to be true }
    end

    context 'when stage is not dev' do
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
    end

    it { expect(klass.mongo_url).to eq 'http://a-fake-url.com'}
  end

  describe '.branch_name' do
    before do
      allow(ENV).to receive(:fetch).and_return('branch')
    end

    it { expect(klass.branch_name).to eq 'branch'}
  end

  describe '.region' do
    before do
      allow(ENV).to receive(:fetch).and_return('region')
    end

    it { expect(klass.region).to eq 'region'}
  end

  describe '.version' do
    it { expect { klass.version }.not_to raise_error }
  end

  describe '.application_description' do
    it { expect { klass.application_description }.not_to raise_error }
  end

  describe '.application' do
    it { expect(klass.application).to include('cloud_template')}
  end

  describe '.application_serverless' do
    it { expect(klass.application_serverless).to eq 'cloud-template'}
  end

  describe '.account' do
    before do
      allow(ENV).to receive(:fetch).and_return('aws account')
    end
    it { expect(klass.account ).to eq 'aws account'}

    context 'when error' do
      before do
        allow(ENV).to receive(:fetch).and_raise
        allow(JSON).to receive(:parse).and_return({ 'Account' => 'account' })
        allow_any_instance_of(Object).to receive(:`).and_return(nil)
      end

      it { expect(klass.account).to eq 'account' }
    end
  end

  describe '.api_keys' do
    context 'when prod' do
      before do
        allow(klass).to receive(:prod?).and_return(true)
      end

      it { expect(klass.api_keys).to eq [{"name"=>"prodKey"}]}
    end

    context 'when not prod' do
      before do
        allow(klass).to receive(:prod?).and_return(false)
      end

      it { expect(klass.api_keys).to eq [{"name"=>"devKey"}]}
    end
  end

  describe '.correct_coverage?' do
    context 'when greater than 80' do
      let(:hash) do
        {
          'result' => {
            'line' => 81
          }
        }
      end

      it 'returns true' do
        expect(klass.correct_coverage?(hash)).to be true
      end
    end
    
    context 'when less than than 80' do
      let(:hash) do
        {
          'result' => {
            'line' => 79
          }
        }
      end

      it 'returns false' do
        expect(klass.correct_coverage?(hash)).to be false
      end
    end
  end

  describe '.best_coverage?' do
    context 'when greater than 95' do
      let(:hash) do
        {
          'result' => {
            'line' => 96
          }
        }
      end

      it 'returns true' do
        expect(klass.best_coverage?(hash)).to be true
      end
    end

    context 'when less than than 95' do
      let(:hash) do
        {
          'result' => {
            'line' => 94
          }
        }
      end

      it 'returns false' do
        expect(klass.best_coverage?(hash)).to be false
      end
    end
  end

end