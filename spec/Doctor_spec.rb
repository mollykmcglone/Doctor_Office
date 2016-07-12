require('rspec')
require('spec_helper')

describe 'Doctor' do
  describe '#initialize' do
    it "creates a new Dorctor object" do
      test_doc = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: 1})
      expect(test_doc.first_name()).to(eq('Test'))
    end
  end

  describe '.all' do
    it "is an array of doctors that is empty at first" do
      expect(Doctor.all()).to(eq([]))
    end
  end

  describe '#save' do
    it "saves a doctor and sets the doctor_id" do
      test_doc = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: 1})
      test_doc.save()
      expect(Doctor.all()).to(eq([test_doc]))
    end
  end

  describe '#==' do
    it "compares 2 Doctor objects with same values and returns true" do
      test_doc = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: 1})
      test_doc2 = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: 1})
      expect(test_doc).to(eq(test_doc2))
    end
  end

  describe '.find' do
    it "finds all doctors that has a given specialty_id and returns them in an array" do
      test_doc = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: 1})
      test_doc2 = Doctor.new({first_name: 'Test2', last_name: 'Test2', doctor_id: nil, specialty_id: 1})
      test_doc.save
      test_doc2.save
      expect(Doctor.find(1)).to(eq([test_doc, test_doc2]))
    end
  end

  describe '.find_by_doctor_id' do
    it "finds the doctor with a given doctor_id" do
      test_doc = Doctor.new({first_name: 'Test', last_name: 'Test', doctor_id: nil, specialty_id: 1})
      test_doc.save
      expect(Doctor.find_by_doctor_id(test_doc.doctor_id)).to(eq(test_doc))
    end
  end
end
