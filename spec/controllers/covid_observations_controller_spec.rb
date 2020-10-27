# spec/controllers/covid_observations_controller_spec.rb

require 'rails_helper'

describe CovidObservationsController, type: :controller do
  describe "create" do
    let(:file) { Rack::Test::UploadedFile.new 'spec/fixtures/csv/covid_data.csv', 'text/csv' }

    context 'when success' do
      it 'returns 200' do
        post :create, params: { covid_observations: { attachment: file }}
        allow(File).to receive(:open).and_return(file)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template("index")
        expect(flash[:notice]).to be_present
      end

      it 'renders the index page' do
        post :create, params: { covid_observations: { attachment: file }}
        allow(File).to receive(:open).and_return(file)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template("index")
        expect(flash[:notice]).to be_present
      end

      it 'inserts values to CovidObservation' do
        post :create, params: { covid_observations: { attachment: file }}
        allow(File).to receive(:open).and_return(file)
        covid_observations = CovidObservation.all

        expect(covid_observations.blank?).to be_falsey
        expect(flash[:notice]).to be_present
      end
    end

    context 'when fail' do
      it 'redirects to the index page and displays a flash message' do
        post :create, params: { covid_observations: { attachment: nil }}
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'top' do
    let(:dump) {[
      { observation_date: '2020-01-01', country: 'Country A', confirmed_cases: 100, deaths: 10, recoveries: 4 },
      { observation_date: '2020-01-01', country: 'Country B', confirmed_cases: 100, deaths: 50, recoveries: 0 },
      { observation_date: '2020-01-01', country: 'Country C', confirmed_cases: 100, deaths: 0, recoveries: 100 },
    ]}

    before(:each) do
      CovidObservation.import(dump)
    end

    after(:each) do
      CovidObservation.delete_all
    end

    describe '/top/:statistics' do
      it 'returns a json' do
        get 'top', params: { statistic: 'confirmed', observation_date: '2020-01-01' }
        response_body = JSON.parse(response.body)
        top_level_keys = response_body.keys
        secondary_level_keys = response_body["countries"][0].keys

        expect(top_level_keys).to eq(["observation_date", "countries"])
        expect(secondary_level_keys).to eq(["country", "confirmed", "deaths", "recovered"])
        expect(response_body["countries"].kind_of?(Array)).to be_truthy
      end
    end

    describe '/top/confirmed' do
      it 'returns a json representation of CovidObservations ordered by confirmed statistics' do
        get 'top', params: { statistic: 'confirmed', observation_date: '2020-01-01' }
        response_body = JSON.parse(response.body)
        top_country = response_body['countries'].first
        expect(top_country['country']).to eq('Country A')
        expect(response).to have_http_status(:ok)
      end
    end

    describe '/top/deaths' do
      it 'returns a json representation of CovidObservations ordered by deaths statistics' do
        get 'top', params: { statistic: 'deaths', observation_date: '2020-01-01' }
        response_body = JSON.parse(response.body)
        top_country = response_body['countries'].first
        expect(top_country['country']).to eq('Country B')
        expect(response).to have_http_status(:ok)
      end
    end

    describe '/top/recoveries' do
      it 'returns a json representation of CovidObservations ordered by recoveries statistics' do
        get 'top', params: { statistic: 'recoveries', observation_date: '2020-01-01' }
        response_body = JSON.parse(response.body)
        top_country = response_body['countries'].first
        expect(top_country['country']).to eq('Country C')
        expect(response).to have_http_status(:ok)
      end
    end

    describe '/top/:statistics?max_results' do
      it 'returns a json with a limit based on params for max_results' do
        get 'top', params: { statistic: 'confirmed', observation_date: '2020-01-01', max_results: 2 }
        response_body = JSON.parse(response.body)
        results = response_body['countries'].length
        expect(results).to eq(2)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

# spec/controllers/covid_observations_controller_spec.rb
