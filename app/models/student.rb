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
    subjects.each_value do |sub|
      errors.add(:subjects, 'enter a valid percentage') unless sub.is_a?(Numeric)
    end
  end
end
