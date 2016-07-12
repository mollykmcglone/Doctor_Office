require('spec_helper.rb')
require('capybara/rspec')
require('./app')
require('launchy')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

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
    save_and_open_page
    select 'Test, Test', :from => 'doctors'
    click_button 'Assign Doctor'
    expect(page).to have_no_content('Assign Doctor')
  end


end

describe 'doctor path', {:type => :feature} do
  it "gets to the doctor page" do
    visit '/'
    click_link 'doctors'
    expect(page).to have_content('Doctors')
  end
end

describe 'patient path', {:type => :feature} do
  it "gets to the patient page" do
    visit '/'
    click_link 'patient'
    expect(page).to have_content('Patient')
  end
end
