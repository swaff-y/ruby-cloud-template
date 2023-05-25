# frozen_string_literal: true

require_relative '../../lib/tasks/aws_login'

RSpec.describe Tasks::AwsLogin do
  subject(:task) { described_class.new }

  before do
    allow(Config).to receive(:account).and_return('account')
  end

  describe '.initalise' do
    it 'initalises without error' do
      expect{ task }.not_to raise_error
    end
  end

  describe '#process' do
    context 'when no error' do
      before do
        allow_any_instance_of(Object).to receive(:`).and_return('logged in')
      end

      it 'logs in' do
        expect(task.process).to eq 'logged in'
      end
    end

    context 'when error' do
      before do
        allow_any_instance_of(Object).to receive(:`).and_raise(StandardError, 'Error')
      end

      it 'raises system error' do
        expect { task.process }.to raise_error(SystemExit)
      end
    end
  end
end