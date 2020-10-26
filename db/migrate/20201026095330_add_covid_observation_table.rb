class AddCovidObservationTable < ActiveRecord::Migration[6.0]
  def change
    create_table :covid_observations do |t|
      t.date :observation_date, null: false
      t.string :country, null: false
      t.integer :confirmed_cases, null: false, default: 0
      t.integer :deaths, null: false, default: 0
      t.integer :recoveries, null: false, default: 0

      t.timestamps
      t.index [:observation_date]
    end
  end
end
