module TopStatisticsPresenter
  extend self

  def call(data, observation_date)
    return {} if data.blank?

    countries = data.map do |datum|
      {
        country: datum.country,
        confirmed: datum.confirmed_cases,
        deaths: datum.deaths,
        recovered: datum.recoveries
      }
    end

    {
      observation_date: observation_date,
      countries: countries
    }
  end
end
