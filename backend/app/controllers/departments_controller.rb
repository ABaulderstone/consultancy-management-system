class DepartmentsController < ApplicationController 
  def index
    render json: Department.all 
  end
end