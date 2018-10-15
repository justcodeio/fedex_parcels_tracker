require "spec_helper"
require 'json'
require 'pry'

describe FedexParcelsTracker do
  it "has a version number" do
    expect(FedexParcelsTracker::VERSION).not_to be '1.0.3'
  end
end

describe 'Fedex::Parcel' do
  let(:mock_success) do
    file = File.join('spec', 'responses', 'success.json')
    JSON.parse(File.read(file))
  end

  let(:mock_fail) do
    file = File.join('spec', 'responses', 'fail.json')
    JSON.parse(File.read(file))
  end

  let(:tracker) { Fedex::Parcel }
  let(:initializer) do
    Fedex::Parcel.configure do |c|
      c.wsdl = 'https://poland.fedex.com/xxxxxxxxxxxxxxxxxxxxxx'
      c.access_key = 'Your access key'
      c.method = :pobierz_statusy_przesylki
      c.tracking_in_data = :numerPrzesylki
      c.ssl_version = :TLSv1_2
      c.data = {
        kodDostepu: @access_key,
        numerPrzesylki: nil,
        czyOstatni: 0
      }
    end
  end

  context 'track' do
    it 'returns json response - success' do
      allow(tracker).to receive_message_chain('track').and_return(mock_success)
      response = tracker.track.fetch('statusy_przesylki').first
      expect(response.fetch('nr_p')).to eq('1111111111111')
      expect(response.fetch('opis')).to eq('Kurier doręczył przesyłkę do odbiorcy.')
    end
    it 'returns json response - fail' do
      allow(tracker).to receive_message_chain('track').and_return(mock_fail)
      response = tracker.track.fetch('error')
      expect(response).to eq('Tracking code provided no longer found')
    end

    it 'raises - wrong code error' do
      initializer
      expect { tracker.track('123') }.to raise_error(RuntimeError, 'Invalid tracking code provided')
    end

    it 'raises - nil error' do
      initializer
      expect { tracker.track(nil) }.to raise_error(RuntimeError, 'Tracking code cannot be blank')
    end

    it 'raises - no configuration error' do
      Fedex::Parcel.configuration = nil
      expect { tracker.track(nil) }.to raise_error(RuntimeError, 'No configuration credentials provided !')
    end
  end
end
