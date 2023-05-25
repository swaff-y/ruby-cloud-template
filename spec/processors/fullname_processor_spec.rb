# frozen_string_literal: true

require_relative '../../lib/processors/fullname_processor'

RSpec.describe Processors::FullnameProcessor do
  subject(:processor) { described_class.new('event', 'context', body, path_params, model)}
  let(:body) do
    {
      'fullname' => 'Tom Sawyer',
      'firstname' => 'Tom',
      'lastname' => 'Sawyer'
    }
  end
  let(:path_params) do
    {
      'id' => '12345'
    }
  end
  let(:model) do
    double(:model, find_by_id: person)
  end
  let(:person) do
    {
      'firstname' => 'Tom',
      'lastname' => 'Sawyer'
    }
  end


  describe '.initalize' do
    it 'initalizes without error' do
      expect{ processor }.not_to raise_error
    end
  end

  describe '#process' do
    context 'when type post' do
      it 'returns the fullname' do
        expect(processor.process('post')).to eq 'Tom Sawyer'
      end
    end

    context 'when type put' do
      context 'when name changes' do
        before do
          allow_any_instance_of(described_class).to receive(:name_change?).and_return(true)
        end

        it 'returns the fullname' do
          expect(processor.process('put')).to eq 'Tom Sawyer'
        end
      end

      context 'when no name changes' do
        before do
          allow_any_instance_of(described_class).to receive(:name_change?).and_return(false)
        end

        it 'does not return the fullname' do
          expect(processor.process('put')).to be_nil
        end
      end
    end
  end

  describe 'name_change?' do
    context 'when firstnames dont match' do
      let(:new_person) do
        {
          'firstname' => 'Huckleberry',
          'lastname' => 'Sawyer'
        }
      end

      it 'returns true' do
        processor.instance_variable_set(:@person, new_person)
        expect(processor.name_change?).to be true
      end
    end

    context 'when lastnames dont match' do
      let(:new_person) do
        {
          'firstname' => 'Tom',
          'lastname' => 'Finn'
        }
      end

      it 'returns true' do
        processor.instance_variable_set(:@person, new_person)
        expect(processor.name_change?).to be true
      end
    end

    context 'when match' do
      let(:new_person) do
        {
          'firstname' => 'Tom',
          'lastname' => 'Sawyer'
        }
      end

      it 'returns nil' do
        processor.instance_variable_set(:@person, new_person)
        puts 'Zebra'
        puts processor.instance_variable_get(:@person)
        puts processor.instance_variable_get(:@body)
        expect(processor.name_change?).to be_nil
      end
    end
  end
end