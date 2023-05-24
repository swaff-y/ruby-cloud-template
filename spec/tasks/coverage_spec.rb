# frozen_string_literal: true

require_relative '../../lib/tasks/coverage'

RSpec.describe Tasks::Coverage do
  subject(:coverage) { described_class.new }

  let(:hash) do
    {
      'result' => {
        'line' => 80
      }
    }
  end

  before do
    allow_any_instance_of(Object).to receive(:`).and_return('pwd')
    allow(File).to receive(:read).and_return('read')
    allow(JSON).to receive(:parse).and_return(hash)
  end

  describe '.initalize' do
    it 'initalizes without error' do
      expect { coverage }.not_to raise_error
    end
  end

  describe '.process' do
    before do
      allow(Config).to receive(:logger).and_return('logger')
    end

    context 'when incorrect coverage' do
      before do
        allow(Config).to receive(:correct_coverage?).and_return(false)
      end

      it 'raises the correct error' do
        expect { coverage.process }.to raise_error SystemExit
      end
    end

    context 'when correct coverage' do
      before do
        allow(Config).to receive(:correct_coverage?).and_return(true)
        allow(Config).to receive(:best_coverage?).and_return(false)
      end

      it 'returns the correct log' do
        expect(coverage.process).to eq 'logger'
      end
    end

    context 'when best coverage' do
      before do
        allow(Config).to receive(:correct_coverage?).and_return(true)
        allow(Config).to receive(:best_coverage?).and_return(true)
      end

      it 'exits with system error' do
        expect(coverage.process).to eq 'logger'
      end
    end
  end
end