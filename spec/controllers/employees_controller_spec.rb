# spec/controllers/employees_controller_spec.rb

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:admin) { create(:admin) }
  let(:employee) { create(:employee, admin: admin) }
  let(:valid_attributes) { { name: 'John Doe', email: 'john@example.com', password: 'Password@123', admin_id: admin.id } }
  let(:invalid_attributes) { { name: '', email: 'invalid_email', password: 'short' } }

  # Helper method to simulate user login
  def log_in_as(user)
    session[:employee_id] = user.id if user.is_a?(Employee)
    session[:admin_id] = user.id if user.is_a?(Admin)
  end

  describe "GET #home" do
    context "when logged in as an employee" do
      before { log_in_as(employee) }

      it "redirects to the employee's show page" do
        get :home
        expect(response).to redirect_to(employee_path(employee))
      end
    end

    context "when logged in as an admin" do
      before { log_in_as(admin) }

      it "redirects to the admin dashboard" do
        get :home
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end

    context "when not logged in" do
      it "renders the login page" do
        get :home
        expect(response).to render_template(:login)
      end
    end
  end

  describe "POST #login" do
    context "with valid credentials" do
      it "logs in an employee and redirects to their show page" do
        post :login, params: { session: { email: employee.email, password: 'Password@123' } }
        expect(response).to redirect_to(employee_path(employee))
        expect(session[:employee_id]).to eq(employee.id)
      end

      it "logs in an admin and redirects to the admin dashboard" do
        post :login, params: { session: { email: admin.email, password: 'Password@123' } }
        expect(response).to redirect_to(admin_dashboard_path)
        expect(session[:admin_id]).to eq(admin.id)
      end
    end

    context "with invalid credentials" do
      it "renders the login page with an error message" do
        post :login, params: { session: { email: 'wrong@example.com', password: 'wrong' } }
        expect(response).to render_template(:login)
        expect(flash.now[:danger]).to eq('Invalid email or password')
      end
    end
  end

  describe "GET #signup" do
    it "renders the new employee template with a list of admins" do
      get :signup
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new employee and redirects to the root path" do
        expect {
          post :create, params: { employee: valid_attributes }
        }.to change(Employee, :count).by(1)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #show" do
    context "when logged in as the correct user" do
      before { log_in_as(employee) }

      it "assigns the requested employee and renders the show template" do
        get :show, params: { id: employee.id }
        expect(assigns(:employee)).to eq(employee)
        expect(response).to render_template(:show)
      end
    end

    context "when logged in as an admin" do
      before { log_in_as(admin) }

      it "assigns the requested employee and renders the show template" do
        get :show, params: { id: employee.id }
        expect(assigns(:employee)).to eq(employee)
        expect(response).to render_template(:show)
      end
    end

    context "when not logged in" do
      it "redirects to the root path with an error message" do
        get :show, params: { id: employee.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq('You are not authorized to view this page.')
      end
    end
  end

  describe "DELETE #logout" do
    it "logs out the user and redirects to the root path" do
      log_in_as(employee)
      delete :logout
      expect(response).to redirect_to(root_path)
      expect(session[:employee_id]).to be_nil
      expect(session[:admin_id]).to be_nil
    end
  end
end
