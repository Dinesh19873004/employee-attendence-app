class AttendencesController < ApplicationController
  protect_from_forgery with: :null_session

  def upload
    file = params[:file]
    if file.present?
      Attendence.process_file(file)
      redirect_to admin_dashboard_path, notice: 'Attendance records successfully uploaded.'
    else
      redirect_to admin_dashboard_path, alert: 'Please upload a file.'
    end
  end
end
