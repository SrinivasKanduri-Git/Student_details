class Student
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :student_class, type: String
  field :grade, type: String
  field :subjects, type: Hash
  validates_presence_of(:name, :student_class, :grade, :subjects)

  validate :subject_values

  private

  def subject_values
    subjects.each do |key, value|
      errors.add(:subjects, 'choose correct subject(s)') unless (key == "maths" || key == "english"|| key == "science")
      errors.add(:subjects, 'enter a valid percentage') unless value.is_a?(Numeric)
    end
  end
end
