# frozen_string_literal: true

require_relative '../../lib/lambda/handler'

RSpec.describe 'Handler' do
  describe '.api_status' do
    context 'when event is supplied' do
      let(:status) do
        instance_double(Controllers::Status, get: 'status_get')
      end
      
      before do
        allow(Controllers::Status).to receive(:new).and_return(status)
      end

      it 'returns the correct method' do
        expect(api_status(event: 'event',context: 'context')).to eq 'status_get'
      end
    end

    context 'when event is not supplied' do
      it 'returns the correct hash' do
        expect(api_status(event: nil,context: 'context')).to include('description', 'summary', 'responses', 'security')
      end
    end
  end

  describe '.swagger_status' do
    context 'when event is supplied' do
      let(:swagger) do
        instance_double(Controllers::Swagger, get: 'swagger_get')
      end
      
      before do
        allow(Controllers::Swagger).to receive(:new).and_return(swagger)
      end

      it 'returns the correct method' do
        expect(swagger_status(event: 'event',context: 'context')).to eq 'swagger_get'
      end
    end

    context 'when event is not supplied' do
      it 'returns the correct hash' do
        expect(swagger_status(event: nil,context: 'context')).to include('description', 'summary', 'responses', 'security')
      end
    end
  end

  describe '.get_person_by_id' do
    context 'when event is supplied' do
      let(:expected_allow) do
        instance_double(Controllers::Person, get_by_id: 'person_by_id_get')
      end
      
      before do
        allow(Controllers::Person).to receive(:new).and_return(expected_allow)
      end

      it 'returns the correct method' do
        expect(get_person_by_id(event: 'event',context: 'context')).to eq 'person_by_id_get'
      end
    end

    context 'when event is not supplied' do
      it 'returns the correct hash' do
        expect(get_person_by_id(event: nil,context: 'context')).to include('parameters', 'description', 'summary', 'responses', 'security')
      end
    end
  end

  describe '.get_person' do
    context 'when event is supplied' do
      let(:expected_allow) do
        instance_double(Controllers::Person, get: 'person_get')
      end
      
      before do
        allow(Controllers::Person).to receive(:new).and_return(expected_allow)
      end

      it 'returns the correct method' do
        expect(get_person(event: 'event', context: 'context')).to eq 'person_get'
      end
    end

    context 'when event is not supplied' do
      it 'returns the correct hash' do
        expect(get_person(event: nil, context: 'context')).to include('parameters', 'description', 'summary', 'responses', 'security')
      end
    end
  end

  describe '.post_person' do
    context 'when event is supplied' do
      let(:expected_allow) do
        instance_double(Controllers::Person, post: 'person_post')
      end
      
      before do
        allow(Controllers::Person).to receive(:new).and_return(expected_allow)
      end

      it 'returns the correct method' do
        expect(post_person(event: 'event', context: 'context')).to eq 'person_post'
      end
    end

    context 'when event is not supplied' do
      it 'returns the correct hash' do
        expect(post_person(event: nil, context: 'context')).to include('requestBody', 'description', 'summary', 'responses', 'security')
      end
    end
  end

  describe '.put_person' do
    context 'when event is supplied' do
      let(:expected_allow) do
        instance_double(Controllers::Person, put: 'person_put')
      end
      
      before do
        allow(Controllers::Person).to receive(:new).and_return(expected_allow)
      end

      it 'returns the correct method' do
        expect(put_person(event: 'event', context: 'context')).to eq 'person_put'
      end
    end

    context 'when event is not supplied' do
      it 'returns the correct hash' do
        expect(put_person(event: nil, context: 'context')).to include('parameters', 'requestBody', 'description', 'summary', 'responses', 'security')
      end
    end
  end

  describe '.delete_person' do
    context 'when event is supplied' do
      let(:expected_allow) do
        instance_double(Controllers::Person, delete: 'person_delete')
      end
      
      before do
        allow(Controllers::Person).to receive(:new).and_return(expected_allow)
      end

      it 'returns the correct method' do
        expect(delete_person(event: 'event', context: 'context')).to eq 'person_delete'
      end
    end

    context 'when event is not supplied' do
      it 'returns the correct hash' do
        expect(delete_person(event: nil, context: 'context')).to include('parameters', 'description', 'summary', 'responses', 'security')
      end
    end
  end
end