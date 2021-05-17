class Student

attr_accessor :name, :grade
attr_reader :id

  def initialize(name, grade, id = nil)
    @id = id;
    @name = name;
    @grade = grade;
  end 

  def self.create_table
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      );
    SQL

    DB[:conn].execute(sql)
  end 

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end 

  def save
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
    @id = DB[:conn].execute("SELECT * FROM students WHERE name = ?", self.name).flatten.first
  end 

  def self.create(name:, grade:)
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
    DB[:conn].execute(sql, name, grade)
    student_array = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    student = self.new(student_array[1], student_array[2], student_array[0])
  end 


end
