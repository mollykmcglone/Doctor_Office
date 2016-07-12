class Doctor
  attr_reader(:first_name, :last_name, :doctor_id, :specialty_id)

  define_method(:initialize) do |attributes|
    @first_name = attributes.fetch(:first_name)
    @last_name = attributes.fetch(:last_name)
    @doctor_id = attributes.fetch(:doctor_id)
    @specialty_id = attributes.fetch(:specialty_id)
  end

  define_singleton_method(:all) do
    returned_doctors = DB.exec("SELECT * FROM doctors ORDER BY last_name;")
    doctors = []
    returned_doctors.each() do |doctor|
      first_name = doctor.fetch("first_name")
      last_name = doctor.fetch("last_name")
      doctor_id = doctor.fetch("doctor_id").to_i()
      specialty_id = doctor.fetch("specialty_id").to_i()
      doctors.push(Doctor.new({:first_name => first_name, :last_name => last_name, :doctor_id => doctor_id, :specialty_id => specialty_id}))
    end
    doctors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO doctors (first_name, last_name, specialty_id) VALUES ('#{@first_name}', '#{@last_name}', #{@specialty_id}) RETURNING doctor_id;")
    @doctor_id = result.first().fetch("doctor_id").to_i()
  end

  define_method(:==) do |another_doctor|
    self.first_name == another_doctor.first_name && self.last_name == another_doctor.last_name && self.doctor_id == another_doctor.doctor_id && self.specialty_id == another_doctor.specialty_id
  end

  define_singleton_method(:find) do |specialty_id|
    returned_doctors = DB.exec("SELECT * FROM doctors WHERE specialty_id = #{specialty_id}")
    doctors = []
    returned_doctors.each do |doctor|
      first_name = doctor['first_name']
      last_name = doctor['last_name']
      doctor_id = doctor['doctor_id'].to_i
      specialty_id = doctor['specialty_id'].to_i
      doctors.push(Doctor.new({first_name: first_name, last_name: last_name, doctor_id: doctor_id, specialty_id: specialty_id}))
    end
    doctors
  end

  define_method(:count) do
    DB.exec("SELECT COUNT(*) FROM patients WHERE doctor_id = #{@doctor_id}").to_i
  end
end
