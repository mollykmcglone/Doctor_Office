require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/Doctor')
require('./lib/Patient')
require('pg')

DB = PG.connect({:dbname => "doctor"})

get('/') do
  erb(:index)
end

pages = ['admin', 'doctors']
pages.each do |page|
  get('/' + page) do
    eval('@doctors = Doctor.all
    @patients = Patient.all
    erb(:'+ page +')')
  end
end

get('/patient') do
  @doctors = []
  erb(:patient)
end

add = ['doctor', 'patient']
add.each do |add|
  get('/' + add + '/new') do
    eval('@doctors = []
    erb(:' + add + '_form)')
  end
end

post('/admin/doctor') do
  @doctor = Doctor.new({first_name: params['first_name'], last_name: params['last_name'], doctor_id: nil, specialty_id: params['specialty']})
  @doctor.save
  @doctors = Doctor.all
  @patients = Patient.all
  erb(:admin)
end

post('/admin/patient') do
  @patient = Patient.new({first_name: params['first_name'], last_name: params['last_name'], doctor_id: nil, patient_id: nil, birthdate: params['birthdate']})
  @patient.save
  @doctors = Doctor.all
  @patients = Patient.all
  erb(:admin)
end

post('/admin/assign') do
    @patient = Patient.find_by_patient_id(params['patient_id'])
    @patient.assign(params['doctors'])
    @patients = Patient.all
    @doctors = Doctor.all
  erb(:admin)
end

get('/doctor/:doctor_id') do
  @doctor = Doctor.find_by_doctor_id(params['doctor_id'])
  @patients = Patient.find(params['doctor_id'])
  erb(:doctor)
end

post '/doctors/specialty' do
  @doctors = Doctor.find(params['specialty'])
  erb(:patient)
end
