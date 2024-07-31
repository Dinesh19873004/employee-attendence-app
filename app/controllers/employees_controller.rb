class EmployeesController < ApplicationController
  before_action :require_login, except: [:login, :signup, :new, :create, :home]
  before_action :correct_user, only: [:show]

  def home
    if logged_in?
      puts "current_user is: #{current_user.is_a?(Employee)}"
      redirect_to current_user.is_a?(Employee) ? employee_path(current_user) : admin_dashboard_path
    else
      render :login
    end
  end

  def login
    employee = Employee.find_by(email: login_params[:email])
    admin = Admin.find_by(email: login_params[:email])
    if employee&.authenticate(login_params[:password])
      log_in(employee)
      redirect_to employee_path(employee)
    elsif admin&.authenticate(login_params[:password])
      log_in(admin)
      redirect_to admin_dashboard_path
    else
      flash.now[:danger] = 'Invalid email or password'
      render :login, status: :unauthorized
    end
  end 

  def logout
    log_out
    redirect_to root_path, notice: 'Logged out successfully'
  end

  def signup
    @employee = Employee.new
    @admins = Admin.all
    render :new
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.create!(employee_params)
    redirect_to root_path, notice: 'Employee was successfully created' if @employee
  end

  def admin_dashboard
    if logged_in? && current_user.is_a?(Admin)
      @employees = Employee.page(params[:page]).per(10)
      @admin = current_user
    else
      flash[:danger] = 'You must be logged in as an admin to access this page.'
      redirect_to login_path
    end
  end

  def show
    @employee = Employee.find(params[:id])
    @monthly_attendance = @employee.monthly_attendance
    @yearly_attendance = @employee.yearly_attendance
    @total_hours = @employee.attendences.sum(:working_hours)
    @total_leaves = @employee.attendences.sum(:leaves)
    @total_days_attended = @employee.attendences.where(attended: true).count
  end

  def upload
    @employee = Employee.find(params[:id])
  end

  private

  def require_login
    unless logged_in?
      redirect_to root_path
    end
  end

  def correct_user
    @employee = Employee.find(params[:id])
    unless current_user == @employee || current_user.is_a?(Admin)
      flash[:danger] = 'You are not authorized to view this page.'
      redirect_to root_path
    end
  end

  def login_params
    params.require(:session).permit(:email, :password)
  end

  def employee_params
    params.require(:employee).permit(:name, :email, :password, :admin_id)
  end
end
