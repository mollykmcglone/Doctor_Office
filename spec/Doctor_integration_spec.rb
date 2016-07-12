require('spec_helper.rb')
require('capybara/rspec')
require('./app')
require('launchy')
Capybara.app = Sinatra::Application
# set(:show_exceptions, false)

describe 'admin path', {:type => :feature} do
  it "gets to the admin page" do
    visit '/'
    click_link 'admin'
    expect(page).to have_content('Admin')
  end

  it "add a doctor" do
    visit '/admin'
    click_link 'add_doctor'
    fill_in 'first_name', :with => 'Test'
    fill_in 'last_name', :with => 'Test'
    select 'Pediatrics', :from => 'specialty'
    click_button 'Add'
    expect(page).to have_content('Test')
  end

  it "add a patient" do
    doctor = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: '2'})
    doctor.save()
    visit '/admin'
    click_link 'add_patient'
    fill_in 'first_name', :with => 'Patient'
    fill_in 'last_name', :with => 'Patient'
    fill_in 'birthdate', :with => '2010-08-10'
    click_button 'Add'
    expect(page).to have_content('Test')
  end

  it "assigns a patient to a doctor" do
    doctor = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: '2'})
    doctor.save()
    patient = Patient.new({first_name: 'Patient', last_name: 'Patient', patient_id: nil, doctor_id: nil, birthdate: '2010-08-10'})
    patient.save()
    visit '/admin'
    select 'Test, Test', :from => 'doctors'
    click_button 'Assign Doctor'
    expect(page).to have_no_content('Assign Doctor')
  end
end

describe 'doctor path', {:type => :feature} do
  it "gets to the doctors page" do
    visit '/'
    click_link 'doctors'
    expect(page).to have_content('Doctors')
  end

  it "allows a user to select a doctor from a list of all doctors" do
    doctor = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: '2'})
    doctor.save
    doctor2 = Doctor.new({first_name: 'first2', last_name: 'last2', doctor_id: nil, specialty_id: '3'})
    doctor2.save
    patient = Patient.new({first_name: 'Patient', last_name: 'Patient', patient_id: nil, doctor_id: nil, birthdate: '2010-08-10'})
    patient.save
    patient.assign(doctor2.doctor_id)
    visit '/doctors'
    click_link 'last2, first2'
    expect(page).to have_content('first2 last2')
    expect(page).to have_content('Patient Patient')
  end
end

describe 'patient path', {:type => :feature} do
  it "gets to the patient page" do
    visit '/'
    click_link 'patient'
    expect(page).to have_content('Patient')
  end

  it "find doctors via specialties" do
    doctor = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: '2'})
    doctor.save
    doctor2 = Doctor.new({first_name: 'first2', last_name: 'last2', doctor_id: nil, specialty_id: '3'})
    doctor2.save
    visit '/patient'
    select 'Family Medicine', :from => 'specialty'
    click_button 'Find Doctors'
    expect(page).to have_content('Test, Test')
  end
end
