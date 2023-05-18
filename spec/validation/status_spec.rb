# frozen_string_literal: true

require_relative '../../lib/validation/status'

RSpec.describe Validation::Status do
  subject(:status) { described_class.new(event, context) }

  let(:event) do
    {
      key: 'value'
    }
  end

  let(:context) do
    {
      context_key: 'context value'
    }
  end

  describe '.initalize' do
    it 'initalizes wthout error' do
      expect { subject }.not_to raise_error
      expect(subject.instance_variable_get(:@event)).to eq event
      expect(subject.instance_variable_get(:@context)).to eq context
    end
  end

  describe '#process' do
    context 'when client name does not equal application name' do
      before do
        allow(Config).to receive(:mongo_client).and_return(double(:database, database: double(:name, name:'db name')))
        allow(Config).to receive(:application).and_return('db name fake')
      end

      it 'raises the correct error' do
        expect { subject.process }.to raise_error Exceptions::ConnectionError, 'Could not connect to the database (db name)'
      end
    end

    context 'when client name does equal application name' do
      before do
        allow(Config).to receive(:mongo_client).and_return(double(:database, database: double(:name, name:'db name')))
        allow(Config).to receive(:application).and_return('db name')
      end

      it 'returns the correct name' do
        expect(subject.process).to eq 'db name'
      end
    end
  end
end