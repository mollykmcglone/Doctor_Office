require('rspec')
require('spec_helper')

describe 'Patient' do
  describe '#initialize' do
    it "creates a new Patient object" do
      test_patient = Patient.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, birthdate: '2010-08-01'})
      expect(test_patient.first_name()).to(eq('Test'))
    end
  end

  describe '.all' do
    it "is an array of patients that is empty at first" do
      expect(Patient.all()).to(eq([]))
    end
  end

  describe '#save' do
    it "saves a patient" do
      test_patient = Patient.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, birthdate: '2010-08-01'})
      test_patient.save()
      expect(Patient.all()).to(eq([test_patient]))
    end
  end

  describe '#==' do
    it "is the same patient if it has the same name, doctor_id and birthdate" do
      test_patient = Patient.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, birthdate: '2010-08-01'})
      test_patient2 = Patient.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, birthdate: '2010-08-01'})
      expect(test_patient).to(eq(test_patient2))
    end
  end

  describe '#assign' do
    it "assigns a patient to a given doctor_id" do
      test_patient = Patient.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, birthdate: '2010-08-01'})
      test_patient.save
      test_patient.assign(1)
      expect(test_patient.doctor_id()).to(eq(1))
    end
  end

  describe '.find' do
    it "finds all patients that have a given doctor_id and returns them in an array" do
      test_patient = Patient.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, birthdate: '2010-08-01'})
      test_patient2 = Patient.new({first_name: 'Test2', last_name: 'Test2', doctor_id: nil, birthdate: '2010-08-01'})
      test_patient.save
      test_patient2.save
      test_patient.assign(1)
      expect(Patient.find(1)).to(eq([test_patient]))
    end
  end
end
