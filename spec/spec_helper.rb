require('rspec')
require('pg')
require('pry')
require('Doctor')
require('Patient')

DB = PG.connect({:dbname => "doctor_test"})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctors *;")
    DB.exec("DELETE FROM patients *;")
    DB.exec("DELETE FROM specialties *;")
  end
end
