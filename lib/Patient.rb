class Patient
  attr_reader(:patient_id, :first_name, :last_name, :doctor_id, :birthdate)

  define_method(:initialize) do |attributes|
    @patient_id = attributes[:patient_id]
    @first_name = attributes.fetch(:first_name)
    @last_name = attributes.fetch(:last_name)
    @doctor_id = attributes.fetch(:doctor_id)
    @birthdate = attributes.fetch(:birthdate)
  end

  define_singleton_method(:all) do
    returned_patients = DB.exec("SELECT * FROM patients;")
    patients = []
    returned_patients.each do |patient|
      patient_id = patient['patient_id'].to_i
      first_name = patient['first_name']
      last_name = patient['last_name']
      doctor_id = patient['doctor_id']
      birthdate = patient['birthdate']
      patients.push(Patient.new({patient_id: patient_id, first_name: first_name, last_name: last_name, doctor_id: doctor_id, birthdate: birthdate}))
    end
    patients
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO patients (first_name, last_name, birthdate) VALUES ('#{@first_name}', '#{@last_name}', '#{@birthdate}') RETURNING patient_id;")
    @patient_id = result.first['patient_id'].to_i
  end

  define_method(:==) do |another_patient|
    self.first_name == another_patient.first_name && self.last_name == another_patient.last_name && self.doctor_id == another_patient.doctor_id && self.birthdate == another_patient.birthdate
  end

  define_method(:assign) do |doctor_id|
    result = DB.exec("UPDATE patients SET doctor_id = #{doctor_id} WHERE patient_id = #{@patient_id} RETURNING doctor_id;")
    @doctor_id = result.first['doctor_id'].to_i
  end

  define_singleton_method(:find) do |doctor_id|
    returned_patients = DB.exec("SELECT * FROM patients WHERE doctor_id = #{doctor_id};")
    patients = []
    returned_patients.each do |patient|
      patient_id = patient['patient_id'].to_i
      first_name = patient['first_name']
      last_name = patient['last_name']
      doctor_id = patient['doctor_id'].to_i
      birthdate = patient['birthdate']
      patients.push(Patient.new({patient_id: patient_id, first_name: first_name, last_name: last_name, doctor_id: doctor_id, birthdate: birthdate}))
    end
    patients
  end

  define_singleton_method(:find_by_patient_id) do |patient_id|
    returned_patient = DB.exec("SELECT * FROM patients WHERE patient_id = #{patient_id};").first()
    patient_id = returned_patient['patient_id'].to_i
    first_name = returned_patient['first_name']
    last_name = returned_patient['last_name']
    doctor_id = returned_patient['doctor_id']
    birthdate = returned_patient['birthdate']
    patient= Patient.new({patient_id: patient_id, first_name: first_name, last_name: last_name, doctor_id: doctor_id, birthdate: birthdate})
  end
end
