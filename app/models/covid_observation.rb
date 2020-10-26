class CovidObservation < ApplicationRecord
  STATISTICS = {
    confirmed: 'confirmed_cases',
    deaths: 'deaths',
    recoveries: 'recoveries'
  }.freeze
end
