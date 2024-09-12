# require 'prawn/table'
class StudentsController < ApplicationController
before_action :find_student, only: %i[show update download destroy]

  def show
    render json: @student
  end

  def download
    stu = @student
    @pdf = Prawn::Document.generate("#{stu.name}_details.pdf") do
      text 'Student details:', style: :bold, size: 20
      text "Name: #{stu.name}"
      text "Class: #{stu.student_class}"
      text "Grade: #{stu.grade}"
      sub = [["Subjects", "Percentage"]]
      stu.subjects.each do |key, val|
        sub << [key.to_s, val]
      end
      table(sub)
    end
    send_data @pdf, filename: "#{@student.name}_details.pdf", type: 'application/pdf', disposition: 'inline'
  end

  def index
    students = Student.all
    pdf = Prawn::Document.generate("student_details.pdf") do
      text 'All Students details:', style: :bold, size: 20
      move_down(20)
      stu_table = [["ID", "Name", "Class", "Grade", "Subjects", "Percentage"]]
      i=1
      students.each do |stu|
        stu_table << [stu.id.to_s, stu.name, stu.student_class, stu.grade, [], []]
        stu.subjects.each do |key, value|
          # stu_table << [stu.id.to_s, stu.name, stu.student_class, stu.grade, key, value]
          stu_table[i][4].push([key])
          stu_table[i][5].push([value])
        end
        i+=1
      end
      table(stu_table)
    end
    send_data pdf, filename: "student_details.pdf", type: 'application/pdf', disposition: 'inline'
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy!
    render json: {message: 'student details deleted.'}
  end

  private

  def find_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :student_class, :grade, subjects: {})
  end
end
