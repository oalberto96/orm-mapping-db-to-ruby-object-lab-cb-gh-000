require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.grade = 10
    LIMIT ?
    SQL
    result = DB[:conn].execute(sql, x)
    self.array_from_raw_data(result)
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    SQL
    result = DB[:conn].execute(sql)
    self.array_from_raw_data(result)
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def self.array_from_raw_data(data)
    students = []
    data.each {|row| students << self.new_from_db(row) }
    students
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.grade = 9
    SQL
    result = DB[:conn].execute(sql)
    self.array_from_raw_data(result)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.grade < 12
    SQL
    result = DB[:conn].execute(sql)
    self.array_from_raw_data(result)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.name = ?
    SQL
    result = DB[:conn].execute(sql, name).first
    self.new_from_db(result)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
