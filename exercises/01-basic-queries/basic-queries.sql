-- Create a table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INTEGER,
    grade CHAR(2)
);

-- Insert some data
INSERT INTO students (name, age, grade) VALUES ('Alice', 21, 'A');
INSERT INTO students (name, age, grade) VALUES ('Bob', 22, 'B');
INSERT INTO students (name, age, grade) VALUES ('Charlie', 20, 'A');

-- Basic SELECT queries
SELECT * FROM students;
SELECT name, grade FROM students WHERE grade = 'A';
SELECT COUNT(*) FROM students;