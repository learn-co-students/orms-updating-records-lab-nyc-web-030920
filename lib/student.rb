require_relative "../config/environment.rb"

class Student

    attr_reader :id
    attr_accessor :name, :grade

    def initialize(id=nil, name, grade)
      @id = id
      @name = name
      @grade = grade
    end

    def self.create_table
      sql = <<-SQL
        CREATE TABLE students(
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT
        )
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
      if self.id
        sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
      else
        sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?,?)
        SQL
        DB[:conn].execute(sql,self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid()FROM students")[0][0]
      end
    end

    def self.create(name, grade)
      sql = <<-SQL
      INSERT INTO students (name,grade)
      VALUES (?,?)
      SQL
      DB[:conn].execute(sql, name, grade)
    end

    def self.new_from_db(row)
      id = row[0]
      name = row[1]
      grade = row[2]
      Student.new(id, name, grade)
    end

    def self.find_by_name(name)
      sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      SQL
      DB[:conn].execute(sql, name).map do |row|
        Student.new_from_db(row)
      end.first #above returns an array with the object inside of it. So ask for 1st element
    end

    def update
      sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
