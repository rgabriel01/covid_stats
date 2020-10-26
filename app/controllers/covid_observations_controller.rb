class CovidObservationsController < ApplicationController
  def index
    @covid_observations = CovidObservation.all
  end

  def create
    covid_observation_file = params["covid_observations"]["attachment"]
    observations = ::CSV.read(covid_observation_file.path)
    parsed_values = CovidObservationServices.parse(observations)
    result = CovidObservation.import(parsed_values)

    if result.present?
      flash.now[:notice] = 'Covid observations imported!'
    else
      flash.alert[:alert] = 'Covid observations importation failed!'
    end

    render :index
  end
end
