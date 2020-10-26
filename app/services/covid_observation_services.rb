class CovidObservationServices
  def initialize(covid_observation_data)
    @raw_data = covid_observation_data[1...]
  end

  def self.parse(covid_observation_data)
    new(covid_observation_data).parse
  end

  def parse
    sanitized_values = sanitize_observation_data(@raw_data)
    convert_data_to_hash(sanitized_values)
  end

  private

  def sanitize_observation_data(observation_data)
    observation_data.reject do |data|
      _line_number, observation_date, _province_state, country = data
      observation_date.blank? || country.blank?
    end
  end

  def group_by_country_by_date(data)
    result = []
    data_by_country = data.group_by { |datum| datum[:country] }
    data_by_country.keys.each do |country_key|
      country_data = data_by_country[country_key]
      country_data_by_dates = country_data.group_by {|dd| dd[:observation_date]}
      country_data_by_dates.keys.each do |date_key|
        tmp = country_data_by_dates[date_key]
        total_confirmed_cases = tmp.sum {|dd| dd[:confirmed_cases].to_i}
        total_deaths = tmp.sum {|dd| dd[:deaths].to_i}
        total_recoveries = tmp.sum {|dd| dd[:recoveries].to_i}
        result << {
          observation_date: Date.strptime(date_key, '%m/%d/%Y').strftime('%d-%m-%Y'),
          country: country_key,
          confirmed_cases: total_confirmed_cases,
          deaths: total_deaths,
          recoveries: total_recoveries
        }
      end
    end
    result
  end

  def convert_data_to_hash(data)
    hash = data.map do |observation|
      _line_number,observation_date, _province_state, country, _last_update, confirmed_cases, deaths, recoveries = observation
      {
        observation_date: observation_date,
        country: country,
        confirmed_cases: confirmed_cases,
        deaths: deaths,
        recoveries: recoveries
      }
    end
    group_by_country_by_date(hash)
  end
end
