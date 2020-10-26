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

  def top
    observation_date = params["observation_date"]
    statistic = params["statistic"] || 'confirmed'
    max_results = params["max_results"] || 10

    results = CovidObservation
      .where(observation_date: observation_date)
      .order("#{CovidObservation::STATISTICS[statistic.to_sym]} desc")
      .limit(max_results.to_i)

    render json: TopStatisticsPresenter.call(results, observation_date)
  end
end
