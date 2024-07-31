module SessionsHelper
  def log_in(user)
    if user.is_a?(Employee)
      session[:employee_id] = user.id
      session.delete(:admin_id)
    elsif user.is_a?(Admin)
      session[:admin_id] = user.id
      session.delete(:employee_id)
    end
  end

  def current_user
    @current_user ||= if session[:employee_id]
                        Employee.find_by(id: session[:employee_id])
                      elsif session[:admin_id]
                        Admin.find_by(id: session[:admin_id])
                      end
  end

  def logged_in?
    session[:employee_id] || session[:admin_id] ? true : false
  end

  def log_out
    session.delete(:employee_id)
    session.delete(:admin_id)
    @current_user = nil
  end
end
