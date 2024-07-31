class Attendence < ApplicationRecord
  belongs_to :employee

  def self.process_file(file)
    file_path = Rails.root.join('tmp', file.original_filename)
    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end
    json_data = JsonExcelConvert::Convert.excel_to_json(file_path)
    process_attendance(json_data)
  end

  def self.process_attendance(json_data)
    data = JSON.parse(json_data)
    data.each do |record|
      employee = Employee.find_by(email: record['Email'])
      if employee
        attendance = employee.attendences.find_or_initialize_by(date: record['Date'])
        attendance.update(
          working_hours: record['Working Hours'],
          leaves: record['Leaves'],
          attended: record['Attended']
        )
      end
    end
  end
end
